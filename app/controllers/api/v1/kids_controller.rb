class API::V1::KidsController < API::BaseController
  before_filter :require_authorization!, except: :all
  respond_to :json

  def index
    @kids = current_user.kids
    respond_with @kids.page(params[:page]).per(params[:per]), status: 200
  end

  def create
    @kid = current_user.kids.create permitted_params
    respond_with @kid, status: :created, current_user: current_user, location: api_v1_kids_url(@kid)
  end

  def show
    respond_with resource
  end

  def deliver
    @kid = resource
    @kid.deliver!
    respond_with @kid, status: 200
  end

  def all
    @kids = Kid.all
    respond_with @kids.page(params[:page]).per(6), status: 200
  end

  private
  def resource
    current_user.kids.find(parms[:id])
  end

  def permitted_params
    params.permit(:name, :address, :age, :video, :description)
  end
end