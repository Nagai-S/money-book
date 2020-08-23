class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    # 変数定義
    @events=current_user.events.paginate(page: params[:page])

    # # 最小年を求める
    # min_year=Date.today.year
    # @events.each do |event|
    #   if event.date.year<this_year
    #     min_year=account.date.year
    #   end
    # end

    # # {年:{月:[events],月:[events]...}, 年:{月:[events],月:[events]...}}　作成
    # each_year=Hash.new
    # (min_year..this_year).each do |year|
    #   each_month=Hash.new
    #   (1..12).each do |month|
    #     events=[]
    #     @events.each do |event|
    #       if event.date.year==year && event.date.month==month
    #         events.push(event)
    #       end
    #     end
    #     each_month.store(month,events)
    #   end
    #   each_year.store(year,each_month)
    # end

  end

  def new
    @event=current_user.events.build
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end
  end

  def create1
    # ----------------------------------------------------
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end
    # ----------------------------------------------------

    @event=current_user.events.build(events_params)
    if @event.save
      @event.update(iae: false)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      account.update(value: account.value-@event.value)
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def create2
    # ----------------------------------------------------
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end
    # ----------------------------------------------------

    @event=current_user.events.build(events_params)
    if @event.save
      @event.update(iae: true)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      account.update(value: account.value+@event.value)
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def destroy
    @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
    account=Account.find_by(:user_id => params[:user_id], :name => @event.account)
    if account
      if @event.iae==false
        account.update(value: account.value+@event.value)
      else
        account.update(value: account.value-@event.value)
      end
    end
    @event.destroy
    redirect_to user_events_path
  end

  def edit
    @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end

    if Genre.find_by(:user_id => current_user.id, :name => @event.genre)
      if @event.iae==false
        @genres_e.delete([@event.genre, @event.genre])
        @genres_e.unshift([@event.genre, @event.genre])
      else
        @genres_i.delete([@event.genre, @event.genre])
        @genres_i.unshift([@event.genre, @event.genre])
      end
    else
      flash.now[:danger]="このジャンルは削除されています"
    end
    if Account.find_by(:user_id => current_user.id, :name => @event.account)
      @accounts.delete([@event.account, @event.account])
      @accounts.unshift([@event.account, @event.account])
    else
      flash.now[:danger]="このアカウントは削除されています"
    end
  end

  def update1
    # ----------------------------------------------------
    @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end

    if Genre.find_by(:user_id => current_user.id, :name => @event.genre)
      if @event.iae==false
        @genres_e.delete([@event.genre, @event.genre])
        @genres_e.unshift([@event.genre, @event.genre])
      else
        @genres_i.delete([@event.genre, @event.genre])
        @genres_i.unshift([@event.genre, @event.genre])
      end
    else
      flash.now[:danger]="このジャンルは削除されています"
    end
    if Account.find_by(:user_id => current_user.id, :name => @event.account)
      @accounts.delete([@event.account, @event.account])
      @accounts.unshift([@event.account, @event.account])
    else
      flash.now[:danger]="このアカウントは削除されています"
    end
    # ----------------------------------------------------

    account=Account.find_by(:user_id => current_user.id, :name => @event.account)
    if account
      if @event.iae==false
        account.update(value: account.value+@event.value)
      else
        account.update(value: account.value-@event.value)
      end
    end
    if @event.update(events_params)
      @event.update(iae: false)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      account.update(value: account.value-@event.value)
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "edit"
    end
  end

  def update2
    # ----------------------------------------------------
    @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
    @genres_e=[]
    @genres_i=[]
    current_user.genres.each do |genre|
      if genre.iae==false
        a=["#{genre.name}", "#{genre.name}"]
        @genres_e.push(a)
      else
        a=["#{genre.name}", "#{genre.name}"]
        @genres_i.push(a)
      end
    end

    @accounts=[]
    current_user.accounts.each do |account|
      a=["#{account.name}", "#{account.name}"]
      @accounts.push(a)
    end

    if Genre.find_by(:user_id => current_user.id, :name => @event.genre)
      if @event.iae==false
        @genres_e.delete([@event.genre, @event.genre])
        @genres_e.unshift([@event.genre, @event.genre])
      else
        @genres_i.delete([@event.genre, @event.genre])
        @genres_i.unshift([@event.genre, @event.genre])
      end
    else
      flash.now[:danger]="このジャンルは削除されています"
    end
    if Account.find_by(:user_id => current_user.id, :name => @event.account)
      @accounts.delete([@event.account, @event.account])
      @accounts.unshift([@event.account, @event.account])
    else
      flash.now[:danger]="このアカウントは削除されています"
    end
    # ----------------------------------------------------

    account=Account.find_by(:user_id => current_user.id, :name => @event.account)
    if account
      if @event.iae==false
        account.update(value: account.value+@event.value)
      else
        account.update(value: account.value-@event.value)
      end
    end
    if @event.update(events_params)
      @event.update(iae: true)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      account.update(value: account.value+@event.value)
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "edit"
    end
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
      params.require(:event).permit(:date, :genre, :account, :value, :memo)
    end
end
