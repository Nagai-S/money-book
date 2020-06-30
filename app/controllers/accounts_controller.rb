class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    @accounts=current_user.accounts
  end

  def new
    @account=current_user.accounts.build
  end

  def create
    @account=current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to user_accounts_path
    else
      render "new"
    end
  end

  def destroy
    Account.find(params[:id]).destroy
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
