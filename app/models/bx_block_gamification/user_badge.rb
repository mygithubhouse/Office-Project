module BxBlockGamification
  class UserBadge < BxBlockGamification::ApplicationRecord
    self.table_name = :user_badges
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :badge

    def self.assign_starter_badge
      accounts = AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
       user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Starter")&.id, unlocked: false)
        if account.battery_percentages.where(status: ["decline", "decided"]).count >= 3 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_hard_charger_badge
      accounts = AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Hard charger")&.id, unlocked:false)
        if account.battery_percentages.where(status: ["decline", "decided"]).count >= 7 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_a_roll_badge
      accounts = AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "A roll")&.id, unlocked: false)
        if account.battery_percentages.where(status: ["decline", "decided"]).count >= 14 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_redeemed_badge
      accounts = AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
        missed_day = account.battery_percentages.where(:created_at => (1.day.before.beginning_of_day - 5.days)..(1.day.before.beginning_of_day - 3.days), :status => "undecided")
        recommited_day = account.battery_percentages.where(:created_at => (1.day.before.beginning_of_day - 2.days)..(1.day.before.beginning_of_day), :status => "decided")
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Redeemed")&.id, unlocked: false)
        if missed_day.count >=3 && recommited_day.count >=3 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_fully_charged_badge
      accounts = AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Fully charged")&.id, unlocked: false)
        if account.battery_percentages.sum(:percent) >= 50.0 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_overachiever_badge
      accounts = AccountBlock::Account.includes(:battery_percentages).where(battery_percentages: { created_at: 1.day.before.beginning_of_day, grade: "A", percent: 50.0..},activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Overachiever")&.id, unlocked: false)
        if account.battery_percentages.sum(:percent) >= 50.0 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_camel_badge
      accounts =  AccountBlock::Account.includes(:battery_percentages).where(battery_percentages: { created_at: Date.current-6..Time.current, status: "undecided" },activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Camel")&.id, unlocked: false)
        if account.battery_percentages.where(status: "undecided").count == 7 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_straight_as_badge
      accounts =  AccountBlock::Account.includes(:battery_percentages).where(battery_percentages: { created_at: Date.current-2..Time.current, grade: "A"},activated: true )
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Straight As")&.id, unlocked: false)
        if account.battery_percentages.where(grade: "A").count >= 3 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_discriminatings_badge
      accounts =  AccountBlock::Account.includes(:battery_percentages).where(battery_percentages: { created_at: Date.current-2..Time.current, grade: ["D", "F"]},activated: true )
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Discriminating")&.id, unlocked: false)
        if account.battery_percentages.where(grade: ["D", "F"]).count == 3 && user_badge.present?
          user_badge.update(unlocked: true)
        end
      end
    end

    def self.assign_upgraded_badge
      accounts =  AccountBlock::Account.all.where(activated: true)
      accounts.each do |account|
        user_badge = account.user_badges.where(badge_id: BxBlockGamification::Badge.find_by(name: "Upgraded")&.id, unlocked: false)
        user_badge.update(unlocked: true) if user_badge.present? && account&.car&.maximum_km.to_f > 2.0
      end
    end
  end
end
