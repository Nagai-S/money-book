class CreditsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    form_class
    @credits=current_user.credits
  end

  def new
    form_class
    @credit=current_user.credits.build
    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts << a
    end

    @days=[]
    (1..31).each do |day|
      a=["#{day}", "#{day}"]
      @days << a
    end
  end

  def create
    form_class
    # ----------------------------------------------------
    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts << a
    end

    @days=[]
    (1..31).each do |day|
      a=["#{day}", "#{day}"]
      @days << a
    end
    # ----------------------------------------------------

    @credit=current_user.credits.build(credits_params)
    if @credit.save
      redirect_to user_credits_path
    else
      flash[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def destroy
    form_class
    Credit.find_by(:user_id => params[:user_id], :id => params[:id]).destroy
    redirect_to user_credits_path
  end

  def show
    form_class
    @credit=Credit.find_by(:user_id => params[:user_id], :id => params[:id])
  end

  private
    def correct_user
      @user=User.find(params[:user_id])
      if current_user==@user
      else
        redirect_to root_path
      end
    end

    def credits_params
      params.require(:credit).permit(:name, :account, :pay_date, :month_date)
    end
end
