class AccountExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    @account_exchanges=current_user.account_exchanges
  end

  def new
    @accounts=current_user.accounts
    @account_exchange=current_user.account_exchanges.build
  end

  def create
    @accounts=current_user.accounts
    @account_exchange=current_user.account_exchanges.build(account_exchange_params)
    if @account_exchange.bname==@account_exchange.aname
      flash.now[:danger]="振替元と振替先を変えてください"
      render "new"
    else
      if @account_exchange.save
        before=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
        after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
        before_value=before.value-@account_exchange.value
        after_value=after.value+@account_exchange.value
        before.update(value: before_value)
        after.update(value: after_value)
        redirect_to user_accounts_path
      else
        flash.now[:danger]="正しい値を入力してください"
        render "new"
      end
    end
  end

  def destroy
    a=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
    before=Account.find_by(:user_id => current_user.id, :name => a.bname)
    after=Account.find_by(:user_id => current_user.id, :name => a.aname)
    if before
      before_value=before.value+a.value
      before.update(value: before_value)
    end
    if after
      after_value=after.value-a.value
      after.update(value: after_value)
    end
    a.destroy
    redirect_to user_account_exchanges_path
  end

  def edit
    @account_exchanges=current_user.account_exchanges
    @accounts=current_user.accounts
    @account_exchange=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
    @anames=[]
    @bnames=[]
    @accounts.each do |account|
      name=["#{account.name}","#{account.name}"]
      @anames.push(name)
      @bnames.push(name)
    end

    if Account.find_by(:user_id => params[:user_id], :name => @account_exchange.bname)
      @bnames.delete(["#{@account_exchange.bname}","#{@account_exchange.bname}"])
      @bnames.unshift(["#{@account_exchange.bname}","#{@account_exchange.bname}"])
    else
      flash.now[:danger]="この振替もとアカウントは削除されています"
      render "index"
    end

    if Account.find_by(:user_id => params[:user_id], :name => @account_exchange.aname)
      @anames.delete(["#{@account_exchange.aname}","#{@account_exchange.aname}"])
      @anames.unshift(["#{@account_exchange.aname}","#{@account_exchange.aname}"])
    else
      flash.now[:danger]="この振替先アカウントは削除されています"
      render "index"
    end
  end

  def update
    # ----------------------------------------------------
    @accounts=current_user.accounts
    @account_exchange=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
    @anames=[]
    @bnames=[]
    @accounts.each do |account|
      name=["#{account.name}","#{account.name}"]
      @anames.push(name)
      @bnames.push(name)
    end

    if Account.find_by(:user_id => params[:user_id], :name => @account_exchange.bname)
      @bnames.delete(["#{@account_exchange.bname}","#{@account_exchange.bname}"])
      @bnames.unshift(["#{@account_exchange.bname}","#{@account_exchange.bname}"])
    else
      flash.now[:danger]="この振替もとアカウントは削除されています"
    end

    if Account.find_by(:user_id => params[:user_id], :name => @account_exchange.aname)
      @anames.delete(["#{@account_exchange.aname}","#{@account_exchange.aname}"])
      @anames.unshift(["#{@account_exchange.aname}","#{@account_exchange.aname}"])
    else
      flash.now[:danger]="この振替先アカウントは削除されています"
    end
    # ----------------------------------------------------

    before=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
    after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
    before_value=0
    after_value=0
    if before
      before_value=before.value+@account_exchange.value
    end
    if after
      after_value=after.value-@account_exchange.value
    end

    a=current_user.account_exchanges.build(account_exchange_params)
    if a.bname==a.aname
      flash.now[:danger]="振替元と振替先を変えてください"
      render "edit"
    else
      if @account_exchange.update(account_exchange_params)
          before.update(value: before_value)
          after.update(value: after_value)
          before=Account.find_by(:user_id => current_user.id, :name => @account_exchange.bname)
          after=Account.find_by(:user_id => current_user.id, :name => @account_exchange.aname)
          before_value=before.value-@account_exchange.value
          after_value=after.value+@account_exchange.value
          before.update(value: before_value)
          after.update(value: after_value)
          redirect_to user_account_exchanges_path
      else
        flash.now[:danger]="正しい値を入力してください"
        render "edit"
      end
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
end
