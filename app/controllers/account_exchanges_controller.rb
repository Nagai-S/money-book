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
    @account_exchange=current_user.account_exchanges.build(account_exchange_params)
    if @account_exchange.save
      before=Account.find_by(:name => @account_exchange.bname)
      after=Account.find_by(:name => @account_exchange.aname)
      before_value=before.value-@account_exchange.value
      after_value=after.value+@account_exchange.value
      before.update_attributes(value: before_value)
      after.update_attributes(value: after_value)
      redirect_to user_accounts_path
    else
      render 'new'
    end
  end

  def destroy
    a=AccountExchange.find(params[:id])
    before=Account.find_by(:name => a.bname)
    after=Account.find_by(:name => a.aname)
    before_value=before.value+a.value
    after_value=after.value-a.value
    before.update_attributes(value: before_value)
    after.update_attributes(value: after_value)
    a.destroy
    redirect_to user_account_exchanges_path
  end

  def show
  end

  def edit
    
  end

  def update

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
