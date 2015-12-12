class UserKidsController < ApplicationController
  respond_to :html

  def index
  end

  def show
  end

  def destroy
  end

  protected
  def resource
    @user_kid = @current_user.user_kids.find(params[:id])
  end

  def collection
    @user_kids = @current_user.user_kids
  end

  def permitted_params
    params.permit(user_kid: [:id])
  end
end
