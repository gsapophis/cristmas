class API::BaseController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :invalid_params

  module Authentication
    def current_user
      @current_user ||= (authenticate_with_query_param || authenticate_with_headers)
    end

    def require_authorization!
      current_user || render_unauthorized
    end

    def authenticate_with_query_param
      if params[:auth_token]
        find_user_by_token params[:auth_token]
      end
    end

    def authenticate_with_headers
      authenticate_with_http_token do |token, options|
        find_user_by_token token
      end
    end

    def find_user_by_token(token)
      token = AccessToken.where(value: token).first
      token.user if token
    end

    def render_unauthorized
      render json: {message: 'You need to sign in or sign up before continuing.'}, status: :unauthorized, content_type: "application/json"
    end
  end

  include ActionController::ImplicitRender

  include ActionController::Rescue

  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Authentication

  include Roar::Rails::ControllerAdditions

  before_filter :cors_headers
  before_filter :require_authorization!

  respond_to :json

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Accept, Content-Type, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'

    render nothing: true, content_type: 'application/json'
  end


  def render(*args)
    options = args.dup.extract_options!

    if options[:json] && options[:json].is_a?(Hash) &&
        options[:json][:errors].is_a?(ActiveModel::Errors)

      options[:json][:errors] = options[:json][:errors].full_messages

      super options
    else
      super
    end
  end

  def track_user(ip, id, status= :sign_in)
    LoginHistory.create ip: ip, logged_in_at: Time.now, user_id: id, status: status
  rescue
  end

  private

  def cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
  end

  def respond_with(resource_or_collection, options = {})
    super resource_or_collection, options.merge(user: current_user)
  end

  protected

  def check_errors(resp, success_status=200)
    if resp != true && resp != false && resp != nil
      (resp['errors'].present? && resp['errors'].any?) ? 422 : success_status
    else
      resp ? success_status : (resp == nil) ? 204 : 422
    end
  end

  def invalid_params(e)
    render json: { message: [e.message] }, status: 422
  end

  def protect_against_forgery?
    false
  end
end
