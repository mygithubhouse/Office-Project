module BxBlockCommunityforum
  class CommunityForum < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :community_forums

    default_scope { where(status: 'regular') }

    validates :name, :profile_pic, :cover_pic, :description, presence: true, allow_blank: false

    has_one_attached :profile_pic, dependent: :destroy
    has_one_attached :cover_pic, dependent: :destroy

    has_many :community_forum_posts, class_name: 'BxBlockCommunityforum::CommunityForumPost', dependent: :destroy
    has_many :posts, through: :community_forum_posts, class_name: 'BxBlockPosts::Post', dependent: :destroy
    belongs_to :admin, class_name: 'AccountBlock::Account', foreign_key: :account_id

    has_many :join_requests, foreign_key: :community_forum_id, class_name: 'BxBlockCommunityforum::CommunityJoin',
             dependent: :destroy
    has_many :accounts, -> { where('community_joins.status = 0') }, source: :account, through: :join_requests

    has_many :account_blocks, foreign_key: :community_forum_id, class_name: 'BxBlockCommunityforum::CommunityBlock',
             dependent: :destroy
    has_many :blocked_accounts, source: :account, through: :account_blocks

    enum status: %i[regular suspended deleted]

    scope :search_by, -> (search) {
      where(
        "LOWER(name) LIKE LOWER(:search) OR LOWER(description) LIKE LOWER(:search) OR
        LOWER(topics) LIKE LOWER(:search)", search: "%#{search}%"
      )
    }

    def admin?(account)
      admin == account
    end

    def joined?(account)
      accounts.include?(account)
    end

    def followed?(account)
      join_requests.exists?(status: 'default', account_id: account.id, followed: true)
    end

    def blocked?(account)
      blocked_accounts.include?(account)
    end

    def follower_count
      join_requests.default.where(followed: true).where.not(account_id: admin.id).count
    end

    private

    def self.image_url(image)
      if image.attached?
        if Rails.env.development? || Rails.env.test?
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
        else
          image.service_url&.split('?')&.first
        end
      end
    end
  end
end
