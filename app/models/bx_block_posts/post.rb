module BxBlockPosts
  class Post < BxBlockPosts::ApplicationRecord
    self.table_name = :posts

    belongs_to :group, class_name: 'BxBlockAccountGroups::Group'
    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many :comments, class_name: 'BxBlockComments::Comment', dependent: :destroy
  end
end
