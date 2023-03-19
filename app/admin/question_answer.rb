ActiveAdmin.register BxBlockHelpCentre::QuestionAnswer, as: "FAQ" do
	config.clear_action_items!
    action_item only: :index do
      link_to 'New FAQ', '/admin/faqs/new'
    end
	menu label: "FAQ's"
	permit_params :question, :answer

	index :title => "FAQ" do
		selectable_column
		column :question
		column :answer
	  # column :question_sub_type
		actions
	end

	show do |object|
		attributes_table do
			row :question
			row :answer
		end
	end

	form :title => "Edit FAQ" do |f|
		f.inputs do
			f.input :question
			f.input :answer
			# f.input :question_sub_type, include_blank: false
		end
		f.actions
	end
end
  

