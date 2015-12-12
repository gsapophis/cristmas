class KidsController < ApplicationController
  respond_to :html

  def index
  end

  def show
  end

  def destroy
  end

  protected
  def resource
    @kid = @current_user.kids.find(params[:id])
  end

  def collection
    @kids = @current_user.kids.order('created_at DESC')
  end

  def permitted_params
    params.permit(user_kid: [:id])
  end
end
