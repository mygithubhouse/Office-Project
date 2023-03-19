module BxBlockCategories
  class CategorySerializer < BuilderBase::BaseSerializer
    attributes :name, :groups
    attribute :groups do |object, params|
      groups = if params[:search].blank?
                 object.groups
               else
                 search = "%#{params[:search]}%"
                 object.groups.joins(:category).where("groups.name ILIKE :search OR categories.name ILIKE :search", search: search)
               end
      groups.map(&:json_info)
    end
  end
end
