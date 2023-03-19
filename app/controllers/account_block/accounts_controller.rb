module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    require 'httparty'
    BESPOKE_URL = 'http://evdead.com/inventory/getter'
    before_action :validate_json_web_token,
                  only: %i[search accept_privacy_policy accept_term_and_condition update show add_battery_percentage late_battery_percentage]
    before_action :check_answer, only: [:create]
    before_action :check_valid_answer, only: [:update]
    skip_before_action :validate_json_web_token, only: %i[check_email_validation check_user_name_validation]
    before_action :load_account,
                  only: %i[accept_privacy_policy accept_term_and_condition update show add_battery_percentage late_battery_percentage]

    def create
      role = BxBlockRolesPermissions::Role.find_by('lower(name) = :name',
                                                   { name: (params[:data][:attributes][:role] || 'Free').downcase })
      params[:data][:attributes].merge!(role_id: role&.id)
      params[:data][:attributes].delete(:role)
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account'
        validate_json_web_token

        unless valid_token?
          return render json: { errors: [
            { token: 'Invalid Token' }
          ] }, status: :bad_request
        end

        begin
          @sms_otp = SmsOtp.find(@token[:id])
        rescue ActiveRecord::RecordNotFound => e
          return render json: { errors: [
            { phone: 'Confirmed Phone Number was not found' }
          ] }, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        if @account.save
          byebug
          render json: SmsAccountSerializer.new(@account, meta: {
                                                  token: encode(@account.id)
                                                }).serializable_hash, status: :created
        else
          render json: { errors: format_activerecord_errors(@account.errors) },
                 status: :unprocessable_entity
        end

      when 'email_account'
        query_email = account_params['attributes']['email'].downcase
        account = EmailAccount.where('LOWER(email) = ?', query_email).first
        validator = EmailValidation.new(account_params['attributes']['email'])
        if account || !validator.valid?
          return render json: { errors: [
            { message: account ? 'Email is already in use' : 'Email invalid' }
          ] }, status: :unprocessable_entity
        end
        @account = EmailAccount.new
        @account.platform = request.headers['platform'].downcase if request.headers.include?('platform')
        if @account.update(account_params['attributes'])
          # EmailAccount.create_stripe_customers(@account)
          EmailValidationMailer
            .with(account: @account, host: request.base_url, token: encode(@account.id))
            .activation_email.deliver
          params[:data][:attributes][:answer_attributes].each do |arr|
            @account.create_answer(arr[:question_id], arr[:answer])
          end
          render json: EmailAccountSerializer.new(@account, meta: {
                                                    token: encode(@account.id)
                                                  }).serializable_hash, status: :created

        else
          render json: { errors: format_activerecord_errors(@account.errors) },
                 status: :unprocessable_entity
        end

      when 'social_account'
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
                                                     token: encode(@account.id)
                                                   }).serializable_hash, status: :created
        else
          render json: { errors: format_activerecord_errors(@account.errors) },
                 status: :unprocessable_entity
        end

      else
        render json: { errors: [
          { account: 'Invalid Account Type' }
        ] }, status: :unprocessable_entity
      end
    end

    def search
      @accounts = Account.where(activated: true)
                         .where('first_name ILIKE :search OR '\
                           'last_name ILIKE :search OR '\
                           'email ILIKE :search', search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: { message: 'List of users.' }).serializable_hash,
               status: :ok
      else
        render json: { errors: [{ message: 'Not found any user.' }] }, status: :ok
      end
    end

    def show
      @account = Account.find(params[:id])
      if @account
        render json: AccountSerializer.new(@account, params: { account: @account }).serializable_hash, status: :ok
      else
        render json: { errors: { message: 'Account Not found' } }, status: :unprocessable_entity
      end
    end

    def update
      if @account.update(update_account_params) && update_answer(params[:account][:answer_attributes])
        render json: AccountSerializer.new(@account, meta: {}).serializable_hash,
               status: :ok
      else
        render json: { errors: { message: @account.errors.full_messages } },
               status: :unprocessable_entity
      end
    end

    def check_email_validation
      email = params[:email]
      check_email = Account.where(email: email)
      if check_email.present?
        return render json: { message: ['Blank value is not permitted'] } if email.blank?

        render json: { errors: ['This email is already exists'] }, status: 422
      else
        render json: { message: ['This email is unique'] }, status: 200
      end
    end

    def check_user_name_validation
      username = params[:user_name]
      user = Account.where(user_name: username)
      if user.present?
        render json: { errors: ['This username is already exists'] }, status: 422
      else
        return render json: { message: ['Blank value is not permitted'] } if username.blank?

        render json: { message: ['This username is unique'] }, status: 200
      end
    end

    def accept_privacy_policy
      if @account.update(privacy_policy_accepted_at: Time.now)
        render json: { message: ['Privacy policy update successfully'] }, status: 200
      else
        render json: { errors: [@account.errors] }, status: 422
      end
    end

    def accept_term_and_condition
      if @account.update(term_and_condition_accepted_at: Time.now)
        render json: { message: ['Term and condition update successfully'] }, status: 200
      else
        render json: { errors: [@account.errors] }, status: 422
      end
    end

    def update_answer(change_params)
      @account.answers.delete_all
      change_params.each do |arr|
        if BxBlockCategories::Question.find_by(id: arr[:question_id])&.Text?
          @account.create_answer(arr[:question_id], arr[:answer])
        else
          @account.create_answer(arr[:question_id], JSON.parse(arr[:answer]))
        end
      end
    end

    def add_battery_percentage
      params[:grade] = get_a_grade
      if Time.zone.now.hour < 8
        start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
        end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
      else
        start_time = Time.zone.now.beginning_of_day.plus_with_duration(8.hours)
        end_time = Time.zone.now.end_of_day.plus_with_duration(8.hours)
      end
      return render json: { message: "params missing" } if params[:battery_percentage].blank? &&  params[:grade].blank?
      if @account.battery_percentages.where(created_at:start_time..end_time).blank?
        battery = @account.battery_percentages.new(percent: params[:battery_percentage].to_f, grade: params[:grade])
        return render json: { message: battery.errors } unless battery.save
        render json: { message: 'Your battery percentage add successfully' }
      else
        @account.battery_percentage.update(percent:params[:battery_percentage])
        render json: { message: 'Battery Percentage updated successfully' }
      end
    end


    def late_battery_percentage
      late_charge = @account.previous_night_battery
      if late_charge.nil?
        @account.battery_percentages.create(percent: params[:battery_percentage], late_charge: true, created_at: 1.day.before)
      else
        return render json: { message: late_charge.errors } unless late_charge.update(percent: params[:battery_percentage], late_charge: true)
      end
      render json: { message: 'Your battery percentage updated successfully' }
    end

    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def search_params
      params.permit(:query)
    end

    def account_params
      params.require(:data).permit(attributes: [:last_name, :first_name, :question_choice_type, :full_phone_number,
                                                :country_code, :phone_number, :email, :user_name, :password, :password_confirmation, :role_id, { car_attributes: %i[car_name electric_car_model maximum_km electric_car_year electric_car_make], address_attributes: %i[id address city state_or_province zipcode country] }])
    end

    def check_answer
      params[:data][:attributes][:answer_attributes].each do |arr|
        question = BxBlockCategories::Question.find_by(id: arr[:question_id])
        if question.nil?
          return render json: { errors: "Question with id=#{arr[:question_id]} doesn't exists" },
                        status: 404
        end

        next unless question && !question.Text?
        if (question.options & arr[:answer]).size != arr[:answer].size
          return render json: { errors: 'Answer not permitted' }, status: 422
        end
      end
    end

    def check_valid_answer
      params[:account][:answer_attributes].each do |arr|
        question = BxBlockCategories::Question.find_by(id: arr[:question_id])

        if question.nil?
          return render json: { errors: "Question with id=#{arr[:question_id]} doesn't exists" },
                        status: 404
        end

        next unless question && !question.Text?
        if (question.options & JSON.parse(arr[:answer])).size != JSON.parse(arr[:answer]).size && !question.Text?
          return render json: { errors: 'Answer not permitted' }, status: 422
        end
      end
    end

    def answer_params
      params.require([:account][:answer_attributes].permit(%i[question_id answer]))
    end

    def update_account_params
      params.require(:account).permit(:last_name, :first_name, :question_choice_type, :full_phone_number,
                                      :country_code, :phone_number, :email, :user_name, :password, :password_confirmation, :preconditioning_type, :commute_distance, :comfort_level, :electric_vehicle_break, :other, address_attributes: %i[id address city state_or_province zipcode country], car_attributes: %i[car_name electric_car_model maximum_km electric_car_year electric_car_make])
    end

    def load_account
      @account = AccountBlock::Account.find_by(id: @token.id)
      return unless @account.nil?

      render json: {
        message: "Account doesn't exists"
      }, status: :not_found
    end

    def get_a_grade
      byebug
      grid = BxBlockStatesCities::Zipcode.find_by(code: @account.address.zipcode.to_s)&.grid_type
      unless grid.nil?
        response = HTTParty.get(BESPOKE_URL)
        updated_response =  JSON.parse(response)
        arr = updated_response.select {|hash| hash['grid'] == grid}.first['week']
        grade = arr.select {|hash| hash['dow'] == Date.today.strftime("%A") }[0]['grade']
      end
    end
  end
end
