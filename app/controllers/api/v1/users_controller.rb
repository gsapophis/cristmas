class API::V1::UsersController < API::BaseController
  skip_before_filter :require_authorization!, only: :create
  before_filter :require_authorization!, only: [:password, :show]

  respond_to :json

  def create
    user = User.create(permitted_params)
    respond_with user, status: :created, location: api_v1_users_url(user), represent_with: API::V1::UserRepresenter
  end

  def password
    permitted_params.require 'password'
    permitted_params.require 'password_confirmation'

    current_user.assign_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
    current_user.access_tokens.try(:destroy_all) if current_user.save
    respond_with current_user, status: 200
  end

  def show
    respond_with current_user, status: 200
  end

  private

  def permitted_params
    params.permit(:password, :password_confirmation, :email, :news_letter)
  end
end
