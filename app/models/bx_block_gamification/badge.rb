module BxBlockGamification
  class Badge < BxBlockGamification::ApplicationRecord
    self.table_name = :badges
    has_one_attached :locked_image
    has_one_attached :unlocked_image
    has_many :user_badges, dependent: :destroy
  end
end

