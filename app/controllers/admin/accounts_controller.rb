class Admin::AccountsController < Admin::AdminController
  expose(:accounts) { Account.latest }
	expose(:account)

	before_action :set_breadcrum

	def update
		if account.update_attributes(account_param)
			redirect_to admin_accounts_path, notice: 'Successfully updated account.'
		else
			render action: :edit
		end
	end

	def destroy
		account.destroy if account.present?
		respond_to do |format|
			format.html{redirect_to admin_accounts_path, notice: 'Successfully deleted account.'}
			format.json{ render json: account}
		end		
	end

	private

	def account_param
		params.require(:account).permit(:name, :domain)
	end

	def set_breadcrum
		add_breadcrumb "Home", admin_dashboard_path
		add_breadcrumb "Accounts", admin_accounts_path
		case params[:action].to_s
		when 'new' || 'create'
			add_breadcrumb 'New Account', new_admin_account_path
		when 'edit' || 'Update'
			add_breadcrumb 'Edit Account', edit_admin_account_path(account)
		when 'show'
			add_breadcrumb account.name, admin_account_path(account)
		end
	end

end
