class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:after_sign_in_path_for, :after_sign_up_path_for]
  before_action :correct_user, only: [:after_sign_in_path_for, :after_sign_up_path_for]

  def after_sign_in_path_for(resource)
    user_events_path(current_user) # ログイン後に遷移するpathを設定
  end

  def after_sign_up_path_for(resource)
    user_events_path(current_user) # アカウント作成後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後に遷移するpathを設定
  end

  def form_class
    @form_class="form-group col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3"
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

  def change_pon
    @events=current_user.events
    @account_exchanges=current_user.account_exchanges
    # 未引き落としのクレジットカードが削除されていないか確認
    @events.each do |event|
      if event.pon==false
        credit=Credit.find_by(:user_id => current_user.id, :name => event.account)
        if credit
          if Account.find_by(:user_id => current_user.id, :name => credit.account)
          else
            flash[:danger]="最近使用したクレジットカードと連携しているアカウント(銀行など)が削除されています"
            redirect_to user_events_path
          end
        else
          flash[:danger]="最近使用したクレジットカードが削除されています"
          redirect_to user_events_path
        end
      end
    end
    @account_exchanges.each do |event|
      if event.pon==false
        credit=Credit.find_by(:user_id => current_user.id, :name => event.bname)
        if credit
          if Account.find_by(:user_id => current_user.id, :name => credit.account)
          else
            flash[:danger]="最近使用したクレジットカードと連携しているアカウント(銀行など)が削除されています"
            redirect_to user_events_path
          end
        else
          flash[:danger]="最近使用したクレジットカードが削除されています"
          redirect_to user_events_path
        end
      end
    end

    # 引き落とし日を過ぎていたら計算する
    @events.each do |event|
      if event.pon==false
        if Date.today>=event.pay_date
          credit=Credit.find_by(:user_id => current_user.id, :name => event.account)
          if credit
            c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
            event.update(pon: true)
            c_account.update(value: c_account.value-event.value)
          end
        end
      end
    end
    @account_exchanges.each do |event|
      if event.pon==false
        if Date.today>=event.pay_date
          credit=Credit.find_by(:user_id => current_user.id, :name => event.bname)
          if credit
            c_account=Account.find_by(:user_id => current_user.id, :name => credit.account)
            event.update(pon: true)
            c_account.update(value: c_account.value-event.value)
          end
        end
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
end
