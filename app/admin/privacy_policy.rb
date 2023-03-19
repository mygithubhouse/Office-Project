ActiveAdmin.register BxBlockContactUs::PrivacyPolicy, as: 'Privacy Policy' do
  config.remove_action_item(:destroy)
  permit_params :description, :start_date, :end_date, :policy_type, :last_updated

  index do
    selectable_column
    column 'description' do |terms|
          arr = terms.description.split("\r\n\r\n").each do |para|
              div do
                para
              end
            end
          arr.clear()
      end

    column :start_date
    column :end_date
    actions
  end

  show title: "Privacy Policies" do |_object|
    attributes_table do
      row 'description' do |terms|
        arr= terms.description.split("\r\n\r\n").each do |para|
              div do
              end
            end
          arr.clear()
      end
      row :start_date
      row :end_date
    end
  end
  
  form do |f|
    f.object.policy_type = 'privacy_Policy'
    f.object.last_updated = object.updated_at
    f.inputs do
      f.input :description
      f.input :start_date, as: :datetime_picker
      f.input :end_date, as: :datetime_picker
      f.input :policy_type, value: 'privacy_Policy', as: :hidden
      f.input :last_updated, value: object.updated_at, as: :hidden
    end
    f.actions
  end

  controller do
    def scoped_collection
      BxBlockContactUs::PrivacyPolicy.where(policy_type: 1)
    end

    def create
      policy_params = params.require(:privacy_policy).permit(:policy_type, :description, :start_date, :end_date, :last_updated)
      if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'privacy_Policy').count == 0
        BxBlockContactUs::PrivacyPolicy.create(policy_params)
        redirect_to admin_privacy_policies_path, notice: "Privacy policy was successfully created"
      else
        redirect_to admin_privacy_policies_path, notice: "you can not create more than one record, please update the existing one"
      end
    end
    
    def update  
      policy_update_params = params.require(:privacy_policy).permit(:policy_type, :start_date, :end_date, :description, :last_updated)
        if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'privacy_Policy').update(policy_update_params)
          redirect_to admin_privacy_policies_path, notice: "Privacy Policy was successfully updated" 
        end
    end

    def destroy
      if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'privacy_Policy').count == 1
        redirect_to admin_privacy_policies_path, notice: "you can not delete record" 
      else
        privacy_policy = BxBlockContactUs::PrivacyPolicy.find(params[:id])
        privacy_policy.destroy
        redirect_to admin_privacy_policies_path, notice: "Deleted Successfully" 
      end
    end
  end
end
