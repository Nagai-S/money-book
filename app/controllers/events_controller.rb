class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    form_class
    # 変数定義
    @events=current_user.events.paginate(page: params[:page])
  end

  def new
    form_class
    new_variable
  end

  def create1
    form_class
    new_variable

    @event=current_user.events.build(events_params)
    credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
    c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
    if credit&&c_account
      if @event.save
        @event.update(iae: false)
        account=Account.find_by(:user_id => current_user.id, :name => @event.account)
        if account
          @event.update(pon: true)
          account.update(value: account.value-@event.value)
        elsif credit
          a=f_pay_date(@event.date, credit)
          @event.update(pay_date: a, pon: false)
        end
        redirect_to user_events_path
      else
        flash.now[:danger]="正しい値を入力してください"
        render "new"
      end
    else
      flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
      render "new"
    end
  end

  def create2
    form_class
    new_variable

    @event=current_user.events.build(events_params)
    if @event.save
      @event.update(iae: true, pon: true)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      account.update(value: account.value+@event.value)
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "new"
    end
  end

  def destroy
    form_class

    @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])

    before_change_action
    
    @event.destroy
    redirect_to user_events_path
  end

  def edit
    form_class
    edit_variable
  end

  def update1
    form_class
    edit_variable

    before_change_action

    a=current_user.events.build(events_params_update1)
    credit=Credit.find_by(:user_id => current_user.id, :name => a.account)
    c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
    if credit&&c_account
      if @event.update(events_params_update1)
        @event.update(iae: false)
        account=Account.find_by(:user_id => current_user.id, :name => @event.account)
        credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
        if account
          @event.update(pay_date: nil, pon: true)
          account.update(value: account.value-@event.value)
        elsif credit
          if @event.pay_date==nil
            a=f_pay_date(@event.date, credit)
            @event.update(pay_date: a)
          else
            a=Date.new(@event.pay_date.year, @event.pay_date.month, credit.pay_date)
            @event.update(pay_date: a)
          end

          if @event.pay_date > Date.today
            @event.update(pon: false)
          else
            @event.update(pon: true)
            c_account.update(value: c_account.value-@event.value)
          end
        end
        redirect_to user_events_path
      else
        flash.now[:danger]="正しい値を入力してください"
        render "edit"
      end
    else
      flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
      render "edit"
    end
  end

  def update2
    form_class
    edit_variable

    account=Account.find_by(:user_id => current_user.id, :name => @event.account)
    if account
      if @event.iae==false
        account.update(value: account.value+@event.value)
      else
        account.update(value: account.value-@event.value)
      end
    end
    if @event.update(events_params)
      @event.update(iae: true, pon: true)
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

    def events_params_update1
      params.require(:event).permit(:date, :genre, :account, :value, :memo, :pay_date)
    end

    def new_variable
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

      @accounts_e=[]
      @accounts_i=[]
      current_user.accounts.each do |account|
        a=["#{account.name}", "#{account.name}"]
        @accounts_e.push(a)
        @accounts_i.push(a)
      end

      current_user.credits.each do |credit|
        a=["#{credit.name}", "#{credit.name}"]
        @accounts_e << a
      end
    end

    def edit_variable
      @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
      @credit=Credit.find_by(:user_id => params[:user_id], :name => @event.account)
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

      @accounts_e=[]
      @accounts_i=[]
      current_user.accounts.each do |account|
        a=["#{account.name}", "#{account.name}"]
        @accounts_e.push(a)
        @accounts_i.push(a)
      end

      current_user.credits.each do |credit|
        a=["#{credit.name}", "#{credit.name}"]
        @accounts_e << a
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
        @accounts_e.delete([@event.account, @event.account])
        @accounts_e.unshift([@event.account, @event.account])
        @accounts_i.delete([@event.account, @event.account])
        @accounts_i.unshift([@event.account, @event.account])
      elsif Credit.find_by(:user_id => current_user.id, :name => @event.account)
        @accounts_e.delete([@event.account, @event.account])
        @accounts_e.unshift([@event.account, @event.account])
      else
        flash.now[:danger]="このアカウントまたはクレジットカードは削除されています"
      end
    end

    def before_change_action
      account=Account.find_by(:user_id => params[:user_id], :name => @event.account)
      credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
      if @event.pon==true
        if account
          if @event.iae==false
            account.update(value: account.value+@event.value)
          else
            account.update(value: account.value-@event.value)
          end
        elsif credit
          c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
          if c_account
            c_account.update(value: c_account.value+@event.value)
          end
        end
      end
    end

    def f_pay_date(event_date, credit)
      pay_day=Date.today
      if credit.pay_date > credit.month_date
        if credit.month_date < event_date.day
          a=event_date.next_month
          pay_day=Date.new(a.year, a.month, credit.pay_date)
        else
          pay_day=Date.new(event_date.year, event_date.month, credit.pay_date)
        end
      else
        if credit.month_date < event_date.day
          a=event_date.next_month(2)
          pay_day=Date.new(a.year, a.month, credit.pay_date)
        else
          a=event_date.next_month
          pay_day=Date.new(a.year, a.month, credit.pay_date)
        end
      end

      return pay_day
    end
end
