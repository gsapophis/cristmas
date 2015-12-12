class KidsController < ApplicationController
  respond_to :html

  def index
  end

  def add_to_favorite
    current_user.add_to_faworite(params[:kid_id])
  end

  protected
  def resource
    @kid = current_user.kids.find(params[:id])
  end

  def collection
    @kids = current_user.kids.order('created_at DESC')
  end

  def permitted_params
    params.permit(user_kid: [:id])
  end
end
