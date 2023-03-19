ActiveAdmin.register BxBlockContactUs::PrivacyPolicy, as: 'Terms And Conditions' do
  config.remove_action_item(:destroy)
  permit_params :start_date, :end_date, :policy_type, :description, :last_updated
  menu label: "Terms and Conditions"

  index do
    selectable_column
    column 'Description' do |terms|
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

  show title: "Terms and Conditions Details" do |_object|
    attributes_table title: "Terms and Conditions details" do
      row 'Description' do |terms|
        arr = terms.description.split("\r\n\r\n").each do |para|
              div do
                para
              end
            end
        arr.clear()
      end
      row :start_date
      row :end_date
    end
  end

  form do |f|
    f.object.policy_type = 'terms_and_conditions'
    f.object.last_updated = object.updated_at
    f.inputs do
      f.input :description, :label => "Description"
      f.input :start_date, as: :datetime_picker
      f.input :end_date, as: :datetime_picker
      f.input :policy_type, value: 'terms_and_conditions', as: :hidden
      f.input :last_updated, value: object.updated_at, as: :hidden
    end
      f.actions do
        if resource.persisted?
          f.action :submit, as: :button, label: 'Update Terms and Conditions'
        else
          f.action :submit, as: :button, label: 'Create Terms and Conditions'
          end
      end
    end

  controller do
    def scoped_collection
      BxBlockContactUs::PrivacyPolicy.where(policy_type: 0)
    end

    def create
      policy_params = params.require(:privacy_policy).permit(:policy_type, :start_date, :end_date, :description, :last_updated)
      if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'terms_and_conditions').count == 0
        BxBlockContactUs::PrivacyPolicy.create(policy_params)
        redirect_to admin_terms_and_conditions_path, notice: "Terms and conditions was successfully created"
      else
        redirect_to admin_terms_and_conditions_path, notice: "you can not create more than one record, please update the existing one"
      end
    end

    def update  
        policy_update_params = params.require(:privacy_policy).permit(:policy_type, :start_date, :end_date, :description, :last_updated)
        if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'terms_and_conditions').update(policy_update_params)
          redirect_to admin_terms_and_conditions_path, notice: "Terms and conditions was successfully updated" 
        end
    end


    def destroy
      if BxBlockContactUs::PrivacyPolicy.where(policy_type: 'terms_and_conditions').count == 1
        redirect_to admin_terms_and_conditions_path, notice: "you can not delete record"
      else
        privacy_policy = BxBlockContactUs::PrivacyPolicy.find(params[:id])
        privacy_policy.destroy
        redirect_to admin_terms_and_conditions_path, notice: "Deleted Successfully"
      end
    end
  end
end
