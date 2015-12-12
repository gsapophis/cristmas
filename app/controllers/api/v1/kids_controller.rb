class API::V1::KidsController < API::BaseController
  before_filter :require_authorization!, except: :all
  respond_to :json

  def index
    @kids = VolonterKid.kids_by_volonter(current_user.id)
    respond_with @kids.page(params[:page]).per(params[:per]), status: 200
  end

  def create
    @kid = current_user.kids.create permitted_params
    @kid.volonter_kids.create volonter_id: current_user.id
    respond_with @kid, status: :created, current_user: current_user, location: api_v1_kids_url(@kid)
  end

  def all
    @kids = Kid.all
    respond_with @kids.page(params[:page]).per(6), status: 200
  end

  private
  def permitted_params
    params.permit(:name, :address, :age, :video, :description)
  end
end