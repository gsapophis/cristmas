class HomeController < ApplicationController
  respond_to :html
  layout false, only: :second_page

  def index
    @kids = Kid.all.page(params[:page]).per(6)
  end

  def home
  end

  def second_page
  end

  def more
    if params[:loadedCount].to_i == 6
      render :json => {
        :has_items => true,
        :items => [
            {
                :title => 'title1'
            },
            {
                :title => 'title2'
            },
            {
                :title => 'title3'
            }
        ]
      }
    else
      render :json => {
          :has_items => false,
          :items => [
              {
                  :title => 'title2'
              }
          ]
      }
    end

  end
end
