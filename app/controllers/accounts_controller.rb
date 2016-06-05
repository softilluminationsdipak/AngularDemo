class AccountsController < BaseController
	
	add_breadcrumb "Home", :user_dashboard_path
	add_breadcrumb "Accounts", :accounts_path

	before_action :find_subscription
	
	def index
	end

	def edit
		render :index
	end

	def plan
		if request.post?
			subscription_plan = SubscriptionPlan.find(params[:plan_id])			
			if @subscription.update_attributes(subscription_plan_id: subscription_plan.id)
				flash[:success] =  'Your subscription has been changed.'
			else
				flash[:error] 	= "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
			end
			redirect_to action: :plan
		else
			@plans = SubscriptionPlan.where('id != ?', @subscription.subscription_plan_id).order('amount DESC')#.collect {|p| p.discount = @subscription.discount; p }
		end
	end
	
	def update
		if current_account.update_attributes(account_params)
			redirect_to accounts_path, notice: 'Successfully updated account information.'
		else
			render action: :edit
		end
	end

	def cancel
		if request.post? && !params[:confirm].blank?
			current_account.destroy
			current_user = nil
			reset_session
			redirect_to root_path
		end
	end

	def billing
	end

	private

	def account_params
		params.require(:account).permit(:name)
	end

	def find_subscription
		@subscription = current_account.subscription
	end

end
