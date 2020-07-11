class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
  end

  def edit
  end

  def new
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      a=["#{genre.name}", "#{genre.name}"]
      if genre.iae==false
        @genres_e.push(a)
      else
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end
  end

  def create

  end

  private
    def correct_user
      @user=User.find(params[:user_id])
      if current_user==@user
      else
        redirect_to root_path
      end
    end

    def events_params
      params.require(:event).permit(:date, :genre, :value, :account, :memo, :iae)
    end
end
