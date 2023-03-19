module BxBlockGamification
  class BadgeWorker
    include Sidekiq::Worker

    def perform
      BxBlockGamification::UserBadge.assign_starter_badge
      BxBlockGamification::UserBadge.assign_hard_charger_badge
      BxBlockGamification::UserBadge.assign_a_roll_badge
      BxBlockGamification::UserBadge.assign_redeemed_badge
      BxBlockGamification::UserBadge.assign_fully_charged_badge
      BxBlockGamification::UserBadge.assign_overachiever_badge
      BxBlockGamification::UserBadge.assign_camel_badge
      BxBlockGamification::UserBadge.assign_straight_as_badge
      BxBlockGamification::UserBadge.assign_discriminatings_badge
      BxBlockGamification::UserBadge.assign_upgraded_badge
    end
  end
end
