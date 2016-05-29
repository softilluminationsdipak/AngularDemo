class ReferrersController < BaseController

	before_filter :find_referrer, only: [:edit, :update, :destroy, :show]
	add_breadcrumb "Home", :root_path
	add_breadcrumb "Referrers", :referrers_path

	def index
		@referrers = current_account.referrers
	end

	def new
		add_breadcrumb "New Referrer"
		@referrer = current_account.referrers.build
    @referrer.build_contact unless @referrer.contact.present?
    @referrer.build_address unless @referrer.address.present?
    @referrer.build_insurance_carrier unless @referrer.insurance_carrier.present?		
	end

	def create
		@referrer = current_account.referrers.build(referrer_params)
		if @referrer.save
			redirect_to referrers_path, flash: { success: 'Successfully created referrer.'}
		else
			render action: :new
		end
	end

	def edit
		add_breadcrumb @referrer.name, referrer_path(@referrer)
		add_breadcrumb "Edit Referrer"
	end

	def update
		if @referrer.update_attributes(referrer_params)
			redirect_to referrers_path, flash: {success: 'Successfully updated referrer'}
		else
			render action: :edit
		end
	end

	def destroy
		@referrer.destroy if @referrer.present?
		respond_to do |format|
			format.html{redirect_to referrers_path, notice: 'Successfully deleted referrer.'}
			format.json{ render json: @referrer}
		end		
	end

	def show
		add_breadcrumb @referrer.name
	end

	def checkUniqueSignName
		source 		= params[:referrer][:source]
		referrer 	= current_account.referrers.where('source = ? AND referrers.id != ?', source, params['id'].to_i).try(:last)
		render json: !referrer
	end

	private

	def find_referrer
		@referrer = current_account.referrers.find_by(slug: params[:id])
	end

	def referrer_params
		params.require(:referrer).permit(:email1, :account_id, :source, :npi_uid, :comment, address_attributes: [:id, :street, :street2, :city, :state, :zip], contact_attributes: [:id, :phone1, :phone1_ext, :fax1, :attention, :email1])
	end

end
