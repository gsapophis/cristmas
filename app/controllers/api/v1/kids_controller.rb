class API::V1::KidsController < API::BaseController
  before_filter :require_authorization!, except: [:all, :show_public]
  respond_to :json

  def index
    @kids = current_user.kids.by_status(params[:status] || 2)
    respond_with @kids.page(params[:page]).per(params[:per] || 20), status: 200
  end

  def create
    require_all_params
    @kid = current_user.kids.create permitted_params
    respond_with @kid, status: :created, current_user: current_user, location: api_v1_kids_url(@kid)
  end

  def show
    respond_with resource
  end

  def show_public
    respond_with Kid.find(params[:id])
  end

  def delivered
    require_video
    @kid = resource
    @kid.delivered!(permitted_params[:video])
    respond_with @kid, status: 200
  end

  def all
    @kids = Kid.all.not_delivered
    respond_with @kids.page(params[:page]).per(6), status: 200
  end

  private
  def resource
    current_user.kids.find(params[:id])
  end

  def require_video
    permitted_params.require :video
  end

  def require_all_params
    permitted_params.require :name
    permitted_params.require :address
    permitted_params.require :age
    permitted_params.require :video
    permitted_params.require :description
  end

  def permitted_params
    params.permit(:name, :address, :status, :age, :video, :description)
  end
end