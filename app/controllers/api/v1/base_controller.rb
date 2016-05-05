class Api::V1::BaseController < ApplicationController
	rescue_from ActiveRecord::RecordNotFound, with: :bad_record
	after_action 				:set_access_control_headers
	before_action 			:login_required
	skip_before_filter 	:verify_authenticity_token, if: Proc.new { |c| c.request.format == 'application/json' }

	protected

 	def login_required
    @current_user = AuthToken.find_user_from_auth_token(params[:auth_token])
    unless @current_user.present?
      render_json({
      	result: {
      		messages: "You required to register or login before continue to this action!",
      		status: 401,
      	}
      }.to_json)
    end
  end

  def render_json(json)
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({content_type: :js, text: response})
  end

  def bad_record
    render_json({errors: "No Record Found!", status: 404}.to_json)
  end

  def parameter_errors
    render_json({errors: "You have supplied invalid parameter list.", status: 404}.to_json)
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

end
