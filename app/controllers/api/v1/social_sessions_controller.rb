class API::V1::SocialSessionsController < API::BaseController
  skip_before_filter :require_authorization!
  rescue_from Koala::Facebook::AuthenticationError, with: :wrong_credentials

  before_action do
    params.require :token
  end

  def login
    # render json: { auth_token: token.value, success: true, email: resource.email, avatar_url: resource.avatar.url }
  end

  protected

  def resource
    # @resource ||= UserAuthorization.from_token(params[:provider], params[:token], params[:secret]).user
  end

  def wrong_credentials(e)
    render json: { errors: ['Wrong credentials'] }, status: 401
  end
end
