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

  private
    def correct_user
      @user=User.find(params[:user_id])
      if current_user==@user
      else
        redirect_to root_path
      end
    end
end
