class ProvidersController < BaseController
	def index
	end

	def new
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
	end

	def update
	end

	def destroy
	end

	private

	def provider_params
		params.require(:provider).permit(:clinic_id, :signature_name, :provider_type_code, :tax_uid, :upin_uid, :nycomp_testify, :npi_uid, contact_attributes: [:id, :first_name, :last_name, :phone1, :fax1, :email1, :notes])
	end

end
