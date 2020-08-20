class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    # 変数定義
    this_year=Date.today.year
    this_month=Date.today.month
    @total=0

    @accounts=current_user.accounts
    @events=current_user.events

    # total残高求める
    @accounts.each do |account|
      @total=@total+account.value
    end

    # 最小年を求める
    min_year=Date.today.year
    @events.each do |event|
      if event.date.year<this_year
        min_year=account.date.year
      end
    end

    # {年:{月:[events],月:[events]...}, 年:{月:[events],月:[events]...}}　作成
    each_year=Hash.new
    (min_year..this_year).each do |year|
      each_month=Hash.new
      (1..12).each do |month|
        events=[]
        @events.each do |event|
          if event.date.year==year && event.date.month==month
            events.push(event)
          end
        end
        each_month.store(month,events)
      end
      each_year.store(year,each_month)
    end

    # pmは収支
    @pm_year=Hash.new
    (min_year..this_year).each do |year|
      pm_month=Hash.new
      (1..12).each do |month|
        pm=0.0
        @events.each do |event|
          if event.date.year==year && event.date.month==month
            if event.iae==false
              pm=pm-event.value
            else
              pm=pm+event.value
            end
          end
        end
        pm_month.store(month,pm)
      end
      @pm_year.store(year,pm_month)
    end

  end

  def new
    @account=current_user.accounts.build
  end

  def create
    @account=current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to user_accounts_path
    else
      flash[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def destroy
    Account.find_by(:user_id => params[:user_id], :id => params[:id]).destroy
    redirect_to user_accounts_path
  end

  private
    def correct_user
      @user=User.find(params[:user_id])
      if current_user==@user
      else
        redirect_to root_path
      end
    end

    def accounts_params
      params.require(:account).permit(:name, :value)
    end
end
