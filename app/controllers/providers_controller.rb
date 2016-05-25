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
    
    @provider = current_account.providers.build
    
    @provider.build_contact contactable_type: 'Provider'
    @provider.build_address
    @provider.preload_existing_legacy_ids
    
    legacy_id = @provider.providers_legacy_id_labels.build
    legacy_id.build_legacy_id_label
	end

	def create
		@provider = current_account.providers.build(provider_params)
		if @provider.save
			redirect_to providers_path, notice: 'Provider successfully created.'
		else
			render action: :new
		end
	end

	def show
		add_breadcrumb "Providers", providers_path
		add_breadcrumb @provider.name
	end

	def edit
		add_breadcrumb "Providers", providers_path
		add_breadcrumb "Edit Provider"

		@provider.preload_existing_legacy_ids

    legacy_id = @provider.providers_legacy_id_labels.build
    legacy_id.build_legacy_id_label
	end

	def update
		if @provider.update_attributes(provider_params)
			redirect_to providers_path, notice: 'Provider successfully updated.'
		else
			render action: :edit
		end
	end

	def destroy
		@provider.destroy if @provider.present?
		respond_to do |format|
			format.html{redirect_to providers_path, notice: 'Successfully deleted provider.'}
			format.json{ render json: @provider}
		end		
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
		params.require(:provider).permit(:account_id, :nycomp_testify, :notes, :clinic_id, :signature_name, :provider_type_code, :tax_uid, :upin_uid, :npi_uid, contact_attributes: [:first_name, :last_name, :phone1, :phone1_ext, :fax1, :email1, :id], providers_legacy_id_labels_attributes: [:legacy_id_label_id, :legacy_id_value, :nycomp_testify, :id, legacy_id_label_attributes: [:label, :id] ])
	end

end
