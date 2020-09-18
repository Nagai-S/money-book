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
    new_variable
  end

  def create
    form_class
    new_variable

    @credit=current_user.credits.build(credits_params)
    if @credit.pay_date==@credit.month_date
      flash[:danger]="締め日と引き落とし日を別日にしてください"
      render "new"
      return
    elsif Account.find_by(:user_id => params[:user_id], :name => @credit.name)
      flash[:danger]="同名のアカウントがあるためクレジットカードの名前を変えてください"
      render "new"
      return
    else
      if @credit.save
        redirect_to user_credits_path
        return
      else
        flash[:danger]="正しい値を入力してください"
        render "new"
        return
      end
    end
  end

  def destroy
    form_class
    Credit.find_by(:user_id => params[:user_id], :id => params[:id]).destroy
    redirect_to user_credits_path
  end

  def edit
    form_class
    edit_variable
  end

  def update
    form_class
    edit_variable
    events=current_user.events
    c_events=[]
    events.each do |event|
      if event.account==@credit.name
        c_events << event
      end
    end
    a=current_user.credits.build(credits_params)
    if a.pay_date==a.month_date
      flash[:danger]="締め日と引き落とし日を別日にしてください"
      render "edit"
    elsif Account.find_by(:user_id => params[:user_id], :name => a.name)
      flash[:danger]="同名のアカウントがあるためクレジットカードの名前を変えてください"
      render "edit"
    else
      if @credit.update(credits_params)
        c_events.each do |event|
          c_account=Account.find_by(:user_id => current_user.id, :name => @credit.account)
          a=f_pay_date(event.date, @credit)
          if event.pon==true
            c_account.update(value: c_account.value+event.value)
          end
          if a>Date.today
            event.update(account: @credit.name, pon: false, pay_date: a)
          else
            event.update(account: @credit.name, pon: true, pay_date: a)
            c_account.update(value: c_account.value-event.value)
          end
        end
        redirect_to user_credits_path
      else
        flash[:danger]="正しい値を入力してください"
        render "new"
      end
    end
  end

  def show
    form_class
    @events=current_user.events
    @credit=Credit.find_by(:user_id => params[:user_id], :id => params[:id])
    today=Date.today

    @not_pay=[]
    not_pay_month=Hash.new
    a=0
    b=0
    @events.each do |event|
      if event.pon==false
        if event.account==@credit.name
          if a != event.pay_date.month || b != event.pay_date.year
            if not_pay_month != {}
              @not_pay << not_pay_month
            end

            # Hashの初期化
            not_pay_month=Hash.new
            not_pay_month[:date]=event.pay_date
            not_pay_month[:event]=[]
            not_pay_month[:total]=0
          end

          not_pay_month[:event] << event
          not_pay_month[:total] += event.value
          a=event.pay_date.month
          b=event.pay_date.year
        end
      end
    end
    @not_pay << not_pay_month

    @total_not_pay=0
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

    def new_variable
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

    def edit_variable
      @credit=Credit.find_by(:user_id => params[:user_id], :id => params[:id])
      @accounts=[]
      current_user.accounts.each do |account|
        a=["#{account.name}", "#{account.name}"]
        @accounts << a
      end
      account=Account.find_by(:user_id => current_user.id, :name => @credit.account)
      if account
        @accounts.delete(["#{account.name}", "#{account.name}"])
        @accounts.unshift(["#{account.name}", "#{account.name}"])
      else
        flash[:danger]="連携アカウントは削除されています"
      end

      @pay_days=[]
      @month_days=[]
      (1..31).each do |day|
        a=["#{day}", "#{day}"]
        @pay_days << a
        @month_days << a
      end
      @month_days.delete(["#{@credit.month_date}", "#{@credit.month_date}"])
      @month_days.unshift(["#{@credit.month_date}", "#{@credit.month_date}"])
      @pay_days.delete(["#{@credit.pay_date}", "#{@credit.pay_date}"])
      @pay_days.unshift(["#{@credit.pay_date}", "#{@credit.pay_date}"])
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
