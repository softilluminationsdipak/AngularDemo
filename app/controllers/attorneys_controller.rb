class AttorneysController < BaseController

	before_filter :find_attorney, only: [:edit, :show, :update, :destroy]
	add_breadcrumb "Home", :user_dashboard_path
	add_breadcrumb "Attorneys", :attorneys_path

	def index
		@attorneys = current_account.attorneys
	end

	def new
		add_breadcrumb 'New Attorney', new_attorney_path
		@attorney = current_account.attorneys.build
    @attorney.build_contact unless @attorney.contact.present?
    @attorney.build_address unless @attorney.address.present?
	end

	def create
		add_breadcrumb 'New Attorney', new_attorney_path
		@attorney = current_account.attorneys.build(attorney_params)
		@attorney.build_insurance_carrier(name: "Insurance Carrier #{InsuranceCarrier.count.to_s}", account_id: current_account.id) unless @attorney.insurance_carrier.present?
		if @attorney.save
			redirect_to attorneys_path, flash: {success: 'Successfully created attorney.'}
		else
			render action: :new
		end		
	end

	def show
		add_breadcrumb 'View', attorney_path(@attorney)
	end

	def edit
		add_breadcrumb 'Edit Attorney', edit_attorney_path(@attorney)
	end

	def update
		add_breadcrumb 'Edit Attorney', edit_attorney_path(@attorney)
		if @attorney.update_attributes(attorney_params)
			redirect_to attorneys_path, flash: {success: 'Successfully updated attorney.'}
		else
	    @attorney.build_contact unless @attorney.contact.present?
	    @attorney.build_address unless @attorney.address.present?
	    @attorney.build_insurance_carrier unless @attorney.insurance_carrier.present?			
			render action: :edit
		end
	end

	def destroy
		@attorney.destroy if @attorney.present?
		respond_to do |format|
			format.html{redirect_to attorneys_path, notice: 'Successfully deleted attorney.'}
			format.json{ render json: @attorney}
		end		
	end

	def checkUniqueSignName
		name 			= params[:attorney][:contact_attributes][:company_name]
		attorney 	= current_account.attorneys.includes(:contact).where('contacts.company_name = ? and attorneys.id != ?', name, params['id'].to_i).references(:contact).try(:last)		
		render json: !attorney
	end

	private

	def attorney_params
		params.require(:attorney).permit(:notes, :attorney_name, address_attributes: [:id, :street, :street2, :city, :state, :zipcode], contact_attributes: [:id, :phone1, :phone1_ext, :fax1, :company_name, :attention, :phone2, :phone2_ext, :phone3, :phone3_ext, :email1])
	end

	def find_attorney
		@attorney = current_account.attorneys.find_by(slug: params[:id])
	end

end
