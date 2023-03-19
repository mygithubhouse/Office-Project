module AccountBlock
  class Account < AccountBlock::ApplicationRecord

    validates :email, uniqueness: true
    validate :user_name, on: :create


    has_secure_password
    before_validation :parse_full_phone_number
    before_create :generate_api_key
    has_one :blacklist_user, class_name: 'AccountBlock::BlackListUser', dependent: :destroy
    has_one :car, class_name: 'BxBlockCategories::Car', dependent: :destroy
    has_many :answers, class_name: 'BxBlockCategories::Answer', dependent: :destroy
    has_one :address, class_name: 'BxBlockAddress::Address', as: :addressble, dependent: :destroy
    belongs_to :role, class_name: 'BxBlockRolesPermissions::Role'
    has_and_belongs_to_many :groups ,class_name: "BxBlockAccountGroups::Group" ,join_table: "accounts_groups"
    has_many :posts, class_name: 'BxBlockPosts::Post', dependent: :destroy
    has_many :comments, class_name: 'BxBlockComments::Comment', dependent: :destroy

    has_many :battery_percentages, class_name: 'AccountBlock::BatteryPercentage'
    has_many :user_badges, class_name: 'BxBlockGamification::UserBadge', dependent: :destroy
    after_create :assign_locked_badges
    has_one :notification_reminder_setting, class_name: 'BxBlockNotifsettings::NotificationReminderSetting', dependent: :destroy
    has_one :vacation_mode_setting, class_name: 'BxBlockNotifsettings::VacationModeSetting', dependent: :destroy
    has_one :easy_mode, class_name: 'BxBlockNotifsettings::EasyMode',dependent: :destroy

    self.table_name = :accounts

    include Wisper::Publisher

    after_save :send_new_password_link, if: -> { is_login_limit_exceeded? }
    after_save :set_black_listed_user
    before_save :update_blocked_now, if: -> {blocked_changed?}
    after_create :terms_and_condition

    enum status: %i[regular suspended deleted]
    enum question_choice_type: {"Answer1" => 0, "Answer2" => 1, "Answer3" => 2}
    enum preconditioning_type: {"None" => 0, "Yes" => 1, "No" => 2}


    scope :active, -> { where(activated: true) }
    scope :existing_accounts, -> { where(status: ['regular', 'suspended']) }

    accepts_nested_attributes_for  :address, allow_destroy: true
    accepts_nested_attributes_for  :battery_percentages, allow_destroy: true
    accepts_nested_attributes_for  :car, allow_destroy: true
    after_create :assign_groups

    def update_blocked_now
      self.blocked_now = self.blocked? ? Time.now : nil
      self.sign_in_count = self.blocked? ? (self.sign_in_count + 1): 0
    end

    def terms_and_condition
      self.update(term_and_condition_accepted_at: Time.now)
    end

    def assign_groups
      AccountBlock::AssignBasicGroups.perform_async(id.to_s)
    end

    def name
      "#{first_name} #{last_name}"
    end

    def create_answer(question_id , answer)
      self.answers.create(question_id: question_id, account_id: id, content: answer)
    end

    def experience_group
      cat = BxBlockCategories::Category.find_by(name: 'Experience')
      groups.where(category_id: cat.id).first
    end

    def subscription?
      role.name.downcase == 'subscription'
    end

    def free?
      role.name.downcase == 'free'
    end

    def admin?
      role.name.downcase == "admin"
    end

    def battery_percentage
      if Time.zone.now.hour < 8
        start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
        end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
      else
        start_time = Time.zone.now.beginning_of_day.plus_with_duration(8.hours)
        end_time = Time.zone.now.end_of_day.plus_with_duration(8.hours)
      end
      percent = self.battery_percentages.where(created_at: start_time..end_time).last
      percent
    end

    def previous_night_battery
      if Time.zone.now.hour < 8
        start_time = 2.day.before.beginning_of_day.plus_with_duration(8.hours)
        end_time = 2.day.before.end_of_day.plus_with_duration(8.hours)
      else
        start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
        end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
      end
      percent = self.battery_percentages.where(created_at: start_time..end_time).last
      percent
    end


    def updated_battery_response
      obj = previous_night_battery
      obj&.late_charge == true
    end

    def assign_locked_badges
      # Account.all.each do |acc |
        BxBlockGamification::Badge.first(14).each do| badge |
          BxBlockGamification::UserBadge.find_or_create_by!(badge_id: badge.id , account_id: self.id)
        end
      # end
    end

    private
    def is_login_limit_exceeded?
      self.sign_in_count > 3 ? true : false
    end

    def parse_full_phone_number
      phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = phone.sanitized
      self.country_code      = phone.country_code
      self.phone_number      = phone.raw_national
    end

    def valid_phone_number
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
      end
    end

    def generate_api_key
      loop do
        @token = SecureRandom.base64.tr('+/=', 'Qrt')
        break @token unless Account.exists?(unique_auth_id: @token)
      end
      self.unique_auth_id = @token
    end

    def set_black_listed_user
      if is_blacklisted_previously_changed?
        if is_blacklisted
          AccountBlock::BlackListUser.create(account_id: id)
        else
          blacklist_user.destroy
        end
      end
    end



    # def set_blocked
    #   self.blocked = true
    # end

    def send_new_password_link
      EmailValidationMailer.with(account: self).block_email.deliver
    end
  end
end
