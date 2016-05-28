class InsuranceCarriersController < BaseController
  expose(:insurance_carriers) { current_account.insurance_carriers.alphabetically }	
	expose(:insurance_carrier, attributes: :insurance_carrier_params, finder: :find_by_slug)
	expose(:legacy_id_label_maps) { ProvidersLegacyIdLabel.includes(:provider, :legacy_id_label).where('providers.id IN (?)', current_account.providers.map(&:id)).references(:provider, :legacy_id_label).map{|t| [t.legacy_id_label.label, t.legacy_id_label_id]}}

	before_filter :set_breadcrum
	before_filter :build_resource, only: [:new, :create, :edit, :update]
	
	def create
		if insurance_carrier.save
			redirect_to insurance_carriers_path, flash: {success: 'Successfully created insurance carrier.'}
		else
			render action: :new
		end
	end

	def update
		if insurance_carrier.update_attributes(insurance_carrier_params)
			redirect_to insurance_carriers_path, flash: {success: 'Successfully updated insurance carrier.'}
		else
			render action: :edit
		end
	end

	def destroy
		insurance_carrier.destroy if insurance_carrier.present?
		respond_to do |format|
			format.html{redirect_to insurance_carriers_path, notice: 'Successfully deleted letter.'}
			format.json{ render json: insurance_carrier}
		end		
	end

	def checkUniqueSignName
		name 								= params[:insurance_carrier][:name]
		insurance_carrier 	= current_account.insurance_carriers.where('name = ? and id != ?', name, params['id'].to_i).try(:last)
		render json: !insurance_carrier	
	end

	private

	def build_resource
    insurance_carrier.build_contact(contactable_type: 'InsuranceCarrier') unless insurance_carrier.contact.present?
    insurance_carrier.build_address unless insurance_carrier.address.present?
	end

	def insurance_carrier_params
		params.require(:insurance_carrier).permit(:account_id, :notes, :legacy_id_label_id, :medigap_code, :clinic_code, :claims_office_sub_code, :name, :payer_code, :alias_name, :insurance_carrier_type_code, address_attributes: [:id, :street, :street2, :city, :state, :zipcode], contact_attributes: [:id, :phone1, :phone1_ext, :fax1])
	end

	def set_breadcrum
		add_breadcrumb "Home", user_dashboard_path
		add_breadcrumb "Insurance Carriers", insurance_carriers_path
		case params[:action].to_s
		when 'new' || 'create'
			add_breadcrumb 'New Insurance Carrier', new_insurance_carrier_path
		when 'edit' || 'Update'
			add_breadcrumb 'Edit Insurance Carrier', edit_insurance_carrier_path(insurance_carrier)
		when 'show'
			add_breadcrumb insurance_carrier.name, insurance_carrier_path(insurance_carrier)
		end		
	end

end
