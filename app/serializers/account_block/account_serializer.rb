module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes *[
      :activated,
      :email,
      :full_phone_number,
      :user_name,
      :question_choice_type,
      :preconditioning_type, 
      :commute_distance, 
      :comfort_level, 
      :electric_vehicle_break, 
      :last_name,
      :first_name,
      :country_code,
      :phone_number,
      :other,
      :type,
      :created_at,
      :updated_at,
      :device_token,
      :unique_auth_id,
      :address_attributes,
      :answer_attributes,
      :car_attributes,
    ]


    attribute :country_code do |object|
      object.country_code 
    end

    attribute :phone_number do |object|
      object.phone_number
    end

    attribute :question_choice_type do |object|
      object.question_choice_type
    end

    attribute :address_attributes do |object|
      object.address
    end

    attribute :answer_attributes do |object|
      object.answers.map do |answer|
        {id: answer.id,
        question_id: answer.question_id,
        account_id: answer.account_id,
        content: answer.answer_content,
        question_type: answer.question.question_type,
        answer_type: answer.question.answer_type}
      end
    end

    attribute :car_attributes do |object|
      object.car
    end

    class << self
      private

      def country_code_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).country_code
      end

      def phone_number_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).raw_national
      end
    end
  end
end
