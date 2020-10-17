class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    form_class
    change_pon
    search_variable
    @events=current_user.events.paginate(page: params[:page])
  end

  def search
    form_class
    search_variable
    @search=params[:search]
    @iae=params[:iae]

    @date_or_not=params[:date_or_not]
    month1=params["date1(2i)"]
    day1=params["date1(3i)"]
    if (month1=="4" || month1=="6" || month1=="9" || month1=="11") && day1=="31"
      day1="30"
    elsif month1=="2" && (day1.to_i > 28)
      day1=28
    end

    month2=params["date2(2i)"]
    day2=params["date2(3i)"]
    if (month2=="4" || month2=="6" || month2=="9" || month2=="11") && day2=="31"
      day2="30"
    elsif month2=="2" && (day2>28)
      day2=28
    end

    @date1=Date.new(params["date1(1i)"].to_i,month1.to_i,day1.to_i)
    @date2=Date.new(params["date2(1i)"].to_i,month2.to_i,day2.to_i)

    @genre=params[:genre]
    @account=params[:account]
    @money_or_not=params[:money_or_not]
    @money1=params[:money1]
    @money2=params[:money2]
    search_event=current_user.events
    if @search!=""
      search_event=search_event.where('memo LIKE ?', "%#{@search}%")
    end
    if @iae!="0"
      if @iae=="false"
        search_event=search_event.where(iae: false)
      else
        search_event=search_event.where(iae: true)
      end
    end
    if @date_or_not=="1"
      search_event=search_event.where('date >= ? and date <= ?', @date1, @date2)
    end
    if @genre!="0"
      search_event=search_event.where(genre: @genre)
    end
    if @account!="0"
      search_event=search_event.where(account: @account)
    end
    if @money_or_not=="1"
      search_event=search_event.where('value >= ? and value <= ?', @money1.to_i, @money2.to_i)
    end
    @events=search_event.paginate(page: params[:page])

    @total=0
    search_event.each do |event|
      if event.iae==true
        @total += event.value
      else
        @total -= event.value
      end
    end
    if @date_or_not=="0"
      @css1="none"
    else
      @css1="block"
    end
    if @money_or_not=="0"
      @css2="none"
    else
      @css2="block"
    end
  end

  def new
    form_class
    new_variable
  end

  def create1
    form_class
    new_variable

    @event=current_user.events.build(events_params)
    if @event.save
      @event.update(iae: false)
      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
      if account
        @event.update(pon: true)
        account.update(value: account.value-@event.value)
      elsif credit
        if Account.find_by(:user_id => current_user.id, :name => credit.account)
          a=f_pay_date(@event.date, credit)
          @event.update(pay_date: a, pon: false)
        else
          flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
          @event.destroy
          render 'new' and return
        end
      end
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
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

    after_change_action

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
    if credit
      if Account.find_by(:user_id => current_user.id, :name => credit.account)
      else
        flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
        render 'edit' and return
      end
    end
    if @event.update(events_params_update1)
      @event.update(iae: false)

      after_change_action

      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
      if account
        @event.update(pay_date: nil, pon: true)
        account.update(value: account.value-@event.value)
      elsif credit
        c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
        if @event.pay_date==nil
          a=f_pay_date(@event.date, credit)
          @event.update(pay_date: a)
        else
          a=Date.new(@event.pay_date.year, @event.pay_date.month, credit.pay_date)
          @event.update(pay_date: a)
        end

        if @event.pay_date <= Date.today
          @event.update(pon: true)
          c_account.update(value: c_account.value-@event.value)
        else
          @event.update(pon: false)
        end
      end
      redirect_to user_events_path
    else
      flash.now[:danger]="正しい値を入力してください"
      render "edit"
    end
  end

  def update2
    form_class
    edit_variable

    before_change_action

    if @event.update(events_params)

      after_change_action

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

    def search_variable
      @all_genres=[["すべて","0"]]
      @genres_e=[["すべて","0"]]
      @genres_i=[["すべて","0"]]
      current_user.genres.each do |genre|
        if genre.iae==false
          a=["#{genre.name}", "#{genre.name}"]
          @genres_e.push(a)
        else
          a=["#{genre.name}", "#{genre.name}"]
          @genres_i.push(a)
        end
        a=["#{genre.name}", "#{genre.name}"]
        @all_genres << a
      end

      @accounts_e=[["すべて","0"]]
      current_user.accounts.each do |account|
        a=["#{account.name}", "#{account.name}"]
        @accounts_e.push(a)
      end

      current_user.credits.each do |credit|
        a=["#{credit.name}", "#{credit.name}"]
        @accounts_e << a
      end
    end

    def new_variable
      @credit=false
      @all_genres=[]
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
        a=["#{genre.name}", "#{genre.name}"]
        @all_genres << a
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
      if @event.iae==true
        @taba=""
        @tabb="active"
      else
        @tabb=""
        @taba="active"
      end
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

      genre=Genre.find_by(:user_id => current_user.id, :name => @event.genre)
      if genre
        @genre_s=["#{genre.name}", "#{genre.name}"]
      else
        flash.now[:danger]="このジャンルは削除されています"
      end

      account=Account.find_by(:user_id => current_user.id, :name => @event.account)
      if account || @credit
        @account_s=["#{@event.account}", "#{@event.account}"]
      else
        flash.now[:danger]="このアカウントまたはクレジットカードは削除されています"
      end
    end

    def before_change_action
      @account=Account.find_by(:user_id => params[:user_id], :name => @event.account)
      @account_value=0
      @credit=Credit.find_by(:user_id => current_user.id, :name => @event.account)
      @c_account_value=0
      if @event.pon==true
        if @account
          if @event.iae==false
            @account_value=@account.value+@event.value
          else
            @account_value=@account.value-@event.value
          end
        elsif @credit
          @c_account=Account.find_by(:user_id => current_user.id, :name => @credit.account)
          if @c_account
            @c_account_value=@c_account.value+@event.value
          end
        end
      end
    end

    def after_change_action
      if @account
        @account.update(value: @account_value)
      elsif @credit
        if @c_account
          @c_account.update(value: @c_account_value)
        end
      end
    end

end
