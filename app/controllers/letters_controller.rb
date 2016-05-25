class LettersController < BaseController
  expose(:letters) { current_account.letters }	
	expose(:letter, attributes: :letter_params, finder: :find_by_slug)

	before_filter :set_breadcrum

	def create
		if letter.save
			redirect_to letters_path, notice: 'Successfully created letter!'
		else
			render action: :new
		end
	end

	def update
		if letter.update_attributes(letter_params)
			redirect_to letters_path, notice: 'Successfully updated letter!'
		else
			render action: :edit
		end
	end

	def destroy		
		letter.destroy if letter.present?
		respond_to do |format|
			format.html{redirect_to letters_path, notice: 'Successfully deleted letter.'}
			format.json{ render json: letter}
		end		
	end

	def checkUniqueSignName
		name 		= params[:letter][:name]
		letter 	= current_account.letters.where('name = ? and id != ?', name, params['id'].to_i).try(:last)
		render json: !letter
	end

	private

	def letter_params
		params.require(:letter).permit(:name, :body, :salutation, :should_sign_clinic_name, :account_id)		
	end

	def set_breadcrum
		add_breadcrumb "Home", user_dashboard_path
		add_breadcrumb "Letters", letters_path
		case params[:action].to_s
		when 'new' || 'create'
			add_breadcrumb 'New Letter', new_letter_path
		when 'edit' || 'Update'
			add_breadcrumb 'Edit Letter', edit_letter_path(letter)
		when 'show'
			add_breadcrumb letter.name, letter_path(letter)
		end
	end

end
