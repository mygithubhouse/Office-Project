ActiveAdmin.register BxBlockAccountGroups::Group, as: 'Groups' do
  config.filters = false
  permit_params :name, :category_id

  index do
    column :name
    column 'member_count' do |obj|
      obj.accounts.count
    end
    actions
  end
  form do |f|
    f.inputs  do
      f.input :name
      f.input :category_id, :as => :select, :collection => BxBlockCategories::Category.where(name: 'Custom').collect {|cat| [cat.name, cat.id] }
    end
    f.actions
  end

  show do |group|
    attributes_table do
      row :category
      row :name
      row 'accounts' do
        group.accounts.map(&:name)
      end
   end
  end
end
