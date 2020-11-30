class AccountExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user


  def index
    form_class
    @account_exchanges=current_user.account_exchanges.page(params[:page])
  end

  def new
    form_class
    new_variable
    @account_exchange=current_user.account_exchanges.build
  end

  def create
    form_class
    new_variable

    @account_exchange=current_user.account_exchanges.build(account_exchange_params)
    if @account_exchange.bname==@account_exchange.aname
      flash.now[:danger]="振替元と振替先を変えてください"
      render "new" and return
    else
      if @account_exchange.save
        before_account=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
        before_credit=Credit.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
        after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
        if before_account
          @account_exchange.update(pon: true)
          before_value=before_account.value-@account_exchange.value
          before_account.update(value: before_value)
        else before_credit
          if Account.find_by(:user_id => current_user.id, :name => before_credit.account)
            a=f_pay_date(@account_exchange.date, before_credit)
            @account_exchange.update(pon: false, pay_date: a)
          else
            flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
            @account_exchange.destroy
            render 'new' and return
          end
        end
        after_value=after.value+@account_exchange.value
        after.update(value: after_value)
        redirect_to user_accounts_path
      else
        flash.now[:danger]="正しい値を入力してください"
        render "new"
      end
    end
  end

  def destroy
    form_class
    @account_exchange=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
    before_change_action
    after_change_action
    @account_exchange.destroy
    redirect_to user_account_exchanges_path
  end

  def edit
    form_class
    edit_variable
  end

  def update
    form_class
    edit_variable

    before_change_action

    a=current_user.account_exchanges.build(account_exchange_update_params)
    before_credit=Credit.find_by(:user_id => current_user.id, :name => a.bname)
    if a.bname==a.aname
      flash.now[:danger]="振替元と振替先を変えてください"
      render "edit" and return
    elsif before_credit
      if Account.find_by(:user_id => current_user.id, :name => before_credit.account)
      else
        flash.now[:danger]="選択したクレジットカードと連携しているアカウント(銀行など)が削除されています"
        render 'edit' and return
      end
    end
    if @account_exchange.update(account_exchange_update_params)
      after_change_action
      before_account=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
      before_credit=Credit.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
      if before_account
        @account_exchange.update(pay_date: nil, pon: true)
        before_account.update(value: before_account.value-@account_exchange.value)
      elsif before_credit
        before_c_account=Account.find_by(:user_id => current_user.id, :name => before_credit.account)
        if @account_exchange.pay_date==nil
          a=f_pay_date(@account_exchange.date, before_credit)
          @account_exchange.update(pay_date: a)
        else
          a=Date.new(@account_exchange.pay_date.year, @account_exchange.pay_date.month, before_credit.pay_date)
          @account_exchange.update(pay_date: a)
        end

        if @account_exchange.pay_date <= Date.today
          @account_exchange.update(pon: true)
          before_c_account.update(value: before_c_account.value-@account_exchange.value)
        else
          @account_exchange.update(pon: false)
        end
      end
      after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
      after_value=after.value+@account_exchange.value
      after.update(value: after_value)
      redirect_to user_account_exchanges_path
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

    def account_exchange_params
      params.require(:account_exchange).permit(:date, :bname, :aname, :value)
    end

    def account_exchange_update_params
      params.require(:account_exchange).permit(:date, :bname, :aname, :value, :pay_date)
    end

    def new_variable
      @before_credit=false
      @accounts=current_user.accounts
      @credits=current_user.credits
      @bnames=[]
      @anames=[]
      @accounts.each do |account|
        name=["#{account.name}","#{account.name}"]
        @anames.push(name)
        @bnames.push(name)
      end
      @credits.each do |credit|
        name=["#{credit.name}","#{credit.name}"]
        @bnames << name
      end
    end

    def edit_variable
      @account_exchanges=current_user.account_exchanges.page(params[:page])
      @accounts=current_user.accounts
      @credits=current_user.credits
      @account_exchange=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
      @before_credit=Credit.find_by(:user_id => params[:user_id], :name => @account_exchange.bname)
      @anames=[]
      @bnames=[]
      @accounts.each do |account|
        name=["#{account.name}","#{account.name}"]
        @anames.push(name)
        @bnames.push(name)
      end
      @credits.each do |credit|
        name=["#{credit.name}","#{credit.name}"]
        @bnames << name
      end

      account=Account.find_by(:user_id => params[:user_id], :name => @account_exchange.bname)
      if account || @before_credit
        @bnames_s=["#{@account_exchange.bname}","#{@account_exchange.bname}"]
      else
        flash.now[:danger]="この振替もとアカウントまたはカードは削除されています"
        render "index" and return
      end

      if Account.find_by(:user_id => params[:user_id], :name => @account_exchange.aname)
        @anames_s=["#{@account_exchange.aname}","#{@account_exchange.aname}"]
      else
        flash.now[:danger]="この振替先アカウントは削除されています"
        render "index" and return
      end
    end

    def before_change_action
      @before_account=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
      @before_credit=Credit.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
      @after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
      @before_account_value=0
      @before_c_account_value=0
      @after_value=0
      if @account_exchange.pon==true
        if @before_account
          @before_account_value=@before_account.value+@account_exchange.value
        elsif @before_credit
          @before_c_account=Account.find_by(:user_id => current_user.id, :name => @before_credit.account)
          if @before_c_account
            @before_c_account_value=@before_c_account.value+@account_exchange.value
          end
        end
      end
      if @after
        @after_value=@after.value-@account_exchange.value
      end
    end

    def after_change_action
      if @before_account
        @before_account.update(value: @before_account_value)
      elsif @before_credit
        if @before_c_account
          @before_c_account.update(value: @before_c_account_value)
        end
      end
      if @after
        @after.update(value: @after_value)
      end
    end
end
