ActiveAdmin.register BxBlockContactUs::Contact, as: 'Contact Us' do
  actions :all, except: :new
  
  index do
    selectable_column
    column :name
    column :description
    column :email
    column "Revert Back" do |contact|
    	link_to "Send Mail", revert_back_mail_admin_contact_u_path(contact), method: :post, class: 'button'
    end
  end

  member_action :revert_back_mail, method: [:post] do
  	BxBlockContactUs::ContactUsMailer.with(email: resource.email).revert.deliver
  	flash[:notice] = "Email has been sent"
  	redirect_to admin_contact_us_path
  end
end
