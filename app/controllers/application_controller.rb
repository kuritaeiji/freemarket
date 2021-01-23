class ApplicationController < ActionController::Base
  include(SessionsHelper)

  protect_from_forgery({ with: :exception })

  private
    def log_in_user
      unless logged_in?
        flash[:danger] = 'ログインして下さい。'
        redirect_to(log_in_url)
      end
    end

    def set_referer_to_session
      session[:referer] = request.referer
    end

    def redirect_referer_or(url)
      redirect_to(session[:referer] || url)
      session.delete(:referer)
    end
end