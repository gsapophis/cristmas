class HomeController < ApplicationController
  respond_to :html, :js
  layout false, only: :second_page

  def index
    @kids = Kid.not_delivered.order('created_at DESC').page(params[:page]).per(6)
  end
end
