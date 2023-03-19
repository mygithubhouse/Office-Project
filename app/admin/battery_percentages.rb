ActiveAdmin.register AccountBlock::BatteryPercentage, as: 'Battery percentages' do
  config.filters = false
  permit_params :account_id, :percent, :grade, :late_charge, :created_at

  index do
    column :percent
    column :grade
    column :late_charge
    column :status
    column :account
    actions
  end
  form do |f|
    f.inputs  do
      f.input :percent
      f.input :grade
      f.input :created_at, :as => :datepicker, :html_option => { value: Time.now }
      f.input :late_charge
      f.input :account_id, :as => :select, :collection => AccountBlock::Account.all.collect {|cat| [cat.user_name, cat.id] }
    end
    f.actions
  end

  show do |group|
    attributes_table do
      row :percent
      row :grade
      row :account
      row :status
      row :late_charge
    end
  end
end
