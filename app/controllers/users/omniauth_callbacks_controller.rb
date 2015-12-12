class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    process_omniauth_provider
  end

  private
  def process_omniauth_provider
    @auth = request.env["omniauth.auth"]
    @user = UserAuthorization.from_oauth(@auth).user
    @request_id = request.referer.split('=').last if request.referer.include?('=')

    if @user
      success_redirect
    end
  end

  def success_redirect
    flash[:success]= "You have successfully logged in with your #{ @auth['provider'].capitalize } account"
    sign_in_and_redirect @user
  end
end