class ApplicationController < ActionController::Base
  include(SessionsHelper)

  protect_from_forgery({ with: :exception })

  private
    def log_in_user
      unless logged_in?
        flash[:danger] = 'ログインして下さい。'
        redirect_to(root_url)
      end
    end
end