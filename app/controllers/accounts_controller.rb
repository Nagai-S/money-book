class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    form_class
    # 変数定義
    # this_year=Date.today.year
    # this_month=Date.today.month
    @total=0

    @accounts=current_user.accounts
    @events=current_user.events
    @genres=current_user.genres

    # total残高求める
    @accounts.each do |account|
      @total=@total+account.value
    end

    # 引き落とし後の残高を求める
    @accounts_after=[]
    @accounts.each do |account|
      after_value=account.value
      a=[account.name]
      @events.each do |event|
        if event.pon==false
          credit=Credit.find_by(:user_id => current_user.id, :name => event.account)
          c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
          if c_account==account
            after_value -= event.value
          end
        end
      end
      a << after_value
      @accounts_after << a
    end

    @total_after=0
    @accounts_after.each do |account_after|
      @total_after += account_after[1]
    end

    # アカウント別引き落とし後の残高
    @accounts_all=[]
    @accounts.each do |account|
      a=[account.id, account.name, account.value]
      @accounts_after.each do |account_after|
        if account_after[0]==account.name
          a << account_after[1]
        end
      end
      @accounts_all << a
    end


    # ジャンルの順番変える
    @genres_array_e=[]
    @genres_array_i=[]
    @genres.each do |genre|
      if genre.iae==false
        @genres_array_e << genre.name
      else
        @genres_array_i << genre.name
      end
    end

    # 月ごとの収支
    a=0
    b=0
    @month_pm=Array.new
    month_pm_genre=Hash.new

    @events.each do |event|
      if a != event.date.month || b != event.date.year

        if month_pm_genre != {}
          @month_pm << month_pm_genre
        end

        # Hashの初期化
        month_pm_genre=Hash.new
        month_pm_genre[:year]=event.date.year
        month_pm_genre[:month]=event.date.month
        month_pm_genre[:pm]=0
        month_pm_genre[:in]=0
        month_pm_genre[:out]=0
        @genres.each do |genre|
          month_pm_genre[genre.name]=0
        end
      end

      if event.iae==false
        month_pm_genre[:pm] -= event.value
        month_pm_genre[:out] += event.value
      else
        month_pm_genre[:pm] += event.value
        month_pm_genre[:in] += event.value
      end

      @genres.each do |genre|
        if genre.name==event.genre
          a=month_pm_genre[genre.name]
          if genre.iae==false
            a -= event.value
          else
            a += event.value
          end
          month_pm_genre[genre.name]=a
        end
      end

      a=event.date.month
      b=event.date.year
    end
    @month_pm << month_pm_genre
    @month_pm_paginate=@month_pm.paginate(page: params[:month], per_page:5)

    # 年ごとの収支
    a=0
    @year_pm=Array.new
    year_pm_genre=Hash.new

    @events.each do |event|
      if a!=event.date.year

        if year_pm_genre != {}
          @year_pm << year_pm_genre
        end

        # Hashの初期化
        year_pm_genre=Hash.new
        year_pm_genre[:year]=event.date.year
        year_pm_genre[:pm]=0
        year_pm_genre[:in]=0
        year_pm_genre[:out]=0
        @genres.each do |genre|
          year_pm_genre[genre.name]=0
        end
      end

      if event.iae==false
        year_pm_genre[:pm] -= event.value
        year_pm_genre[:out] += event.value
      else
        year_pm_genre[:pm] += event.value
        year_pm_genre[:in] += event.value
      end

      @genres.each do |genre|
        if genre.name==event.genre
          a=year_pm_genre[genre.name]
          if genre.iae==false
            a -= event.value
          else
            a += event.value
          end
          year_pm_genre[genre.name]=a
        end
      end

      a=event.date.year
    end
    @year_pm << year_pm_genre
    @year_pm_paginate=@year_pm.paginate(page: params[:year], per_page:3)

  end

  def new
    @account=current_user.accounts.build
    form_class
  end

  def create
    form_class
    @account=current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to user_accounts_path
    else
      flash[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def destroy
    form_class
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
