class ProvidersController < BaseController

	before_filter :find_provider, only: [:edit, :update, :destroy, :show]
	add_breadcrumb "Home", :root_path
	
	def index
		add_breadcrumb "Providers", providers_path
		@providers = current_account.providers
	end

	def new
		add_breadcrumb "Providers", providers_path
		add_breadcrumb "New Provider"

		@provider = Provider.new
		@provider.build_contact contactable_type: 'Provider'
		@provider.build_address		
	end

	def create
		@provider = Provider.new(provider_params)
		if @provider.save
			redirect_to providers_path, notice: 'Provider successfully created.'
		else
			render action: :new
		end
	end

	def edit
		add_breadcrumb "Providers", providers_path
		add_breadcrumb "Edit Provider"
	end

	def update
		if @provider.update_attributes(provider_params)
			redirect_to providers_path, notice: 'Provider successfully updated.'
		else
			render action: :edit
		end
	end

	def destroy
	end

	def checkUniqueSignName
		signature_name 	= params[:provider][:signature_name]
		provider 				= current_account.providers.where('signature_name = ? AND providers.id != ?', signature_name, params['id'].to_i).try(:last)
		render json: !provider
	end

	private

	def find_provider
		@provider = current_account.providers.find_by(slug: params[:id])
	end

	def provider_params
		params.require(:provider).permit(:clinic_id, :signature_name, :provider_type_code, :tax_uid, :upin_uid, :nycomp_testify, :npi_uid, contact_attributes: [:id, :first_name, :last_name, :phone1, :fax1, :email1, :notes])
	end

end
