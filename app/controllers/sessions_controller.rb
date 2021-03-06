class SessionsController < ApplicationController
  before_action(:log_in_user, only: [:destroy])

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      if user.activated?
        log_in(user)
        flash[:success] = 'ログインしました。'
        redirect_to(root_url)
      else
        flash[:danger] = 'メールを確認し、アカウントを有効化して下さい。'
        redirect_to(root_url)
      end
    else
      @user = User.new(email: params[:user][:email])
      flash[:danger] = 'メールアドレスまたはパスワードが間違っています。'
      render('new')
    end
  end

  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to(root_url)
  end
end
