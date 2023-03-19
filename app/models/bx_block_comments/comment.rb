module BxBlockComments
  class Comment < BxBlockComments::ApplicationRecord
    self.table_name = :comments

    validates :comment, presence: true

    belongs_to :account,
               class_name: 'AccountBlock::Account'

    belongs_to :post, class_name: 'BxBlockPosts::Post'

    def json_info
      user = account
      {id: id, comment: comment, created_at: "#{time_ago_in_words(created_at)} ago", account_id: account_id, full_name: "#{user.first_name} #{user.last_name}", user_name: user.user_name}
    end
  end
end
