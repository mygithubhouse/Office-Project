ActiveAdmin.register BxBlockGamification::Badge, as: 'Badges' do
  menu label: "Badges"
  config.filters = false
  permit_params :name,:title,:description
  actions :all, except: :new

  show do
    attributes_table do
      row :name
      row :title
      row :description
   end
  end

  index do
    column :name
    column :title
    column :description
    actions
  end
end
