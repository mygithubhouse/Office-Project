module AccountBlock
  class EmailAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :full_phone_number,
      :country_code,
      :phone_number,
      :email,
      :user_name,
      :question_choice_type,
      :preconditioning_type,
      :commute_distance,
      :comfort_level,
      :electric_vehicle_break,
      :other,
      :activated,
      :address_attributes,
      :car_attributes,
      :answer_attributes,
      :terms_and_condition_updated,
      :privacy_policy_updated,
    ]

    attribute :terms_and_condition_updated do |object|
      terms_and_conditions = BxBlockContactUs::PrivacyPolicy.where(policy_type: 'terms_and_conditions').first
      terms_and_conditions.last_updated && (terms_and_conditions.updated_at > terms_and_conditions.last_updated) && object.term_and_condition_accepted_at.nil?
    end

    attribute :privacy_policy_updated do |object|
      privacy_policy = BxBlockContactUs::PrivacyPolicy.where(policy_type: 'privacy_Policy').first
      privacy_policy.last_updated && (privacy_policy.updated_at > privacy_policy.last_updated) && object.privacy_policy_accepted_at.nil?
    end


    attribute :address_attributes do |object|
      object.address
    end

    attribute :answer_attributes do |object|
      object.answers
    end

    attribute :car_attributes do |object|
      object.car
    end

    attribute :is_late_charge_available do |object|
      Time.zone.now.hour.between?(7, 17)
    end

    attribute :battery_percentage do |object|
      object.battery_percentage&.percent
    end

    attribute :last_battery_added do |object|
      object.previous_night_battery&.percent
    end

    attribute :updated_response do |object|
      object.updated_battery_response
    end

  end
end
