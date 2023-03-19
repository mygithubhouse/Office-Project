module BxBlockAccountGroups
  class Group < BxBlockAccountGroups::ApplicationRecord
    self.table_name = :groups
    BASIC_GROUPS = %w(NewUser Experienced Veteran SuperUser SPP MISO ERCOT Offline Tesla NonTesla North South)
    belongs_to :category, class_name: "BxBlockCategories::Category"
    has_and_belongs_to_many :accounts ,class_name: "AccountBlock::Account" ,join_table: "accounts_groups"
    has_many :posts, class_name: 'BxBlockPosts::Post', dependent: :destroy
    validates :name, uniqueness: true
    before_save :restrict_name_updation, if: -> { is_name_changed?}

    before_destroy :restrict_deletion, if: -> { BASIC_GROUPS.include?(self&.name) }

    def json_info
      {id: id, members: accounts.count, name: name}
    end

    private

    def is_name_changed?
      (name_changed? || category_id_changed?) && !new_record?
    end

    def restrict_name_updation
      if BASIC_GROUPS.include?(name_was) || BASIC_GROUPS.include?(name)
        errors.add(:base, "Basic group can't be udpated")
        throw :abort
      end
    end

    def restrict_deletion
      errors.add(:base, "Basic group can't be destroyed")
      throw :abort
    end
  end
end
