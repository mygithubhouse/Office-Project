ActiveAdmin.register BxBlockStatesCities::Zipcode, as: 'Zipcode' do
  permit_params :code, :grid_type

  # filters
  filter :code ,as: :select
  filter :city ,as: :select
  filter :grid_type ,as: :select, collection: {'ERCOT' => 0, 'SPP' => 1, 'MISO' => 2}

  index do
    selectable_column
    column :code
    column :grid_type
    column :city
    actions
  end
end
