class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    @genres=current_user.genres
    @expences=[]
    @incomes=[]
    @genres.each do |genre|
      if genre.iae==false
        @expences.push(genre)
      else
        @incomes.push(genre)
      end
    end
  end

  def new
    @genre=current_user.genres.build
  end

  def create
    @genre=current_user.genres.build(genres_params)
    if @genre.save
      redirect_to user_genres_path(current_user.id)
    else
      render 'new'
    end
  end

  def destroy
    @genre=Genre.find_by(:user_id => params[:user_id], :id => params[:id]).destroy
    redirect_to user_genres_path(params[:user_id])
  end

  def edit
    @genre=Genre.find_by(:user_id => params[:user_id], :id => params[:id])
    if @genre.iae==false
      @selects=[["支出",false],["収入",true]]
    else
      @selects=[["収入",true],["支出",false]]
    end
  end

  def update
    @genre=Genre.find_by(:user_id => params[:user_id], :id => params[:id])
    if @genre.update(genres_params)
      redirect_to user_genres_path(params[:user_id])
    else
      render "edit"
    end
  end

  def show
    @genre=Genre.find_by(:user_id => params[:user_id], :id => params[:id])
  end

  private
    def correct_user
      @user=User.find(params[:user_id])
      if current_user==@user
      else
        redirect_to root_path
      end
    end

    def genres_params
      params.require(:genre).permit(:name, :iae)
    end
end
