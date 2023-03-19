# frozen_string_literal: true

module AccountBlock
  # battery percentage class
  class BatteryPercentage < AccountBlock::ApplicationRecord
    self.table_name = :battery_percentages
    enum status: %i[decline undecided decided]
    belongs_to :account
    before_save :assign_status
    validate :one_record_per_day, on: :create

    def assign_status
      self.status = case percent
                    when nil
                      1
                    when 0
                      0
                    else
                      2
                    end
    end

    def one_record_per_day
      errors.add(:account, 'can not commit more than once a day') if record_valid?
    end

    def record_valid?
      if created_at
        if created_at.hour < 8
          start_time =(created_at - 1.day).beginning_of_day.plus_with_duration(8.hours)
          end_time = (created_at - 1.day).end_of_day.plus_with_duration(8.hours)
        else
          start_time = created_at.beginning_of_day.plus_with_duration(8.hours)
          end_time = created_at.end_of_day.plus_with_duration(8.hours)
        end
      else
        if Time.zone.now.hour < 8
          start_time = 1.day.before.beginning_of_day.plus_with_duration(8.hours)
          end_time = 1.day.before.end_of_day.plus_with_duration(8.hours)
        else
          start_time = Time.zone.now.beginning_of_day.plus_with_duration(8.hours)
          end_time = Time.zone.now.end_of_day.plus_with_duration(8.hours)
        end
      end
      BatteryPercentage.where(account: account,
                              created_at: start_time..end_time).any?
    end
  end
end
