class HomeController < ApplicationController
  respond_to :html

  def index
    @kids = Kid.not_delivered.page(params[:page]).per(6)
  end
end
