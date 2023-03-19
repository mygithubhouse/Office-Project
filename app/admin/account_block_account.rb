ActiveAdmin.register AccountBlock::Account, as: 'Users' do
  permit_params :role_id, :email, :activated, :user_name, :status, :blocked, :created_at, battery_percentages_attributes: [:id, :grade, :percent, :created_at]
  config.filters = false



  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs  do
      f.input :email
      f.input :status
      f.input :user_name
      f.input :activated
      f.input :blocked
      f.input :created_at, :as => :datepicker, :html_option => { value: Time.now }
      f.has_many :battery_percentages do | battery |
        battery.input :percent, placeholder: 'For decline enter null'
        battery.input :grade
        battery.input :created_at, :as => :datepicker, :html_option => { value: Time.now }
      end
    end
    f.actions do
      f.action :submit, as: :input, label: 'Update User'
      f.cancel_link({action: "index"})
    end
  end


    index do
        form do |f|
            div class: "align-dropdown" do
              f.label do
                "Text Message"
              end
              div :style => "font-size: 18px, display: inline-block, flex-direction: row, margin: 18px" do
                f.textarea class: "text_message_account", :style => "display: flex; justify-content: space-between; height: 66px; width: 529px; padding: 10px; font-size: 14px;"
                f.input :updated_at, class: "message_time_pick", type: "datetime-local", min: DateTime.now.to_s, style: "width: 9rem;margin-top: 1rem;padding: 5px; font-size: 13px;"
                div do
                  f.button  id: "send_message_aj",  :style =>  "margin-top: 1rem; margin-bottom: 1rem;" do
                    "send message"
                  end
                end
              end
            end
        end
        selectable_column
        column :email
        column :activated
        column "User name" do |object|
          object.user_name
        end
        column :role
        column "Terms and Conditions accepted at" do |object|
          object.term_and_condition_accepted_at
        end
        column "Privacy Policy accepted at" do |object|
          object.privacy_policy_accepted_at
        end
        column :battery_percentage do |object|
          object.battery_percentage&.percent
        end
        column :blocked
        column "Blocked Time" do |object|
        object.blocked_now
      end

        actions
      div :style => "margin-top: 1rem; margin-bottom: 1rem;" do
              link_to "See all jobs", admin_broadcast_lists_path, class: 'button', target: 'blank'
      end
    end

    member_action :update_role, method: [:put, :patch] do
      role = resource.free? ? BxBlockRolesPermissions::Role.find_by(name: "Subscription") : BxBlockRolesPermissions::Role.find_by(name: "Free")
      resource.update(role_id: role.id)
      redirect_to resource_path, notice: "Role updated successfully"
    end


    show do |object|
      attributes_table do
      row :id
      row :role
      row :email
      row :activated
      row :user_name
      row :status
      row :is_blacklisted
      row :groups
      row 'created_at' do
        "#{time_ago_in_words(object.created_at)} ago"
      end
      row :question_choice_type
      row "Terms & Conditions Created At/Accepted At" do
        object.created_at.getlocal
      end
      row "Updated role" do
        link_to "#{object.free? ? 'Upgrade to premium' : 'Downgrade to free'}", update_role_admin_user_path(object), method: :put, class: "link"
      end
    end
  end
end

