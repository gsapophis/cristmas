class API::V1::SessionsController < API::BaseController
  skip_before_filter :require_authorization!, only: :create

  before_action do
    params.require :email
    params.require :password
  end

  def create
    if resource && resource.valid_password?(params[:password])
      if resource
        success
      else
        render json: { message: resource.try(:errors).try(:messages) }, status: 401
      end
    else
      invalid_login_attempt
    end
  end

  protected

  def resource
    @resource ||= Volonter.find_for_database_authentication(email: params[:email])
  end

  def success
    token = AccessToken.create!(volonter: resource)
    render json: { auth_token: token.value.to_s,
                   success: true,
                   email: resource.email }, status: 200
  end

  def invalid_login_attempt
    render json: { message: 'Incorrect username or password' }, status: 401
  end
end
