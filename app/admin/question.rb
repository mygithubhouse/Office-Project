ActiveAdmin.register BxBlockCategories::Question, as: 'Questions Section' do
	permit_params :content, :question_type, :answer_type, :display, option: []

	index do
		selectable_column
		column :question_type
		column :answer_type
		column :content
		column :options
		column :display
		actions
	end

	form do |f|
		f.inputs do
		text_content = "This is sample Text for Answer Type Text"
		dropdowns_text = 'This is sample text for Answer Type Dropdown ,Checkbox and RadioButton 

6:00 am, 7:00 am, 8:00 am, 9:00 am, 10:00 am, 11:00 am, 12:00 am, 1:00 pm, 2:00 pm, 3:00 pm, 4:00 pm, 5:00 pm'

			f.input :content
			f.input :display
			f.input :question_type, as: :select, include_blank: false
			f.input :answer_type, as: :select, include_blank: false
			placeholder_value = f.object.answer_type == 'Text' ? text_content : dropdowns_text
			value = f.object.answer_type == 'Text' ? '' : f.object.options.to_csv.gsub("\n", "").gsub(",", ", ")
			f.input :options, collection: [], multiple: true, placeholder: placeholder_value, class: 'form-control', autofocus: true, input_html: {value: value}
		end
	f.actions
	end

	controller do
		def create
			question_params = params.require(:question).permit(:content, :answer_type, :question_type, :display, options: [])
			question_params[:options] = params[:question][:options].split(',').map(&:strip) unless params[:question][:answer_type] == "Text"
			BxBlockCategories::Question.create(question_params)
			redirect_to admin_questions_sections_path
		end

		def update
			question_params = params.require(:question).permit(:content, :answer_type, :question_type, :display, options: [])
			question_params[:options] = params[:question][:options].split(',').map(&:strip) unless params[:question][:answer_type] == "Text"
			BxBlockCategories::Question.update(question_params)
			redirect_to admin_questions_sections_path
		end
	end
end
  

