class PasswordResetsController < ApplicationController
  before_action(:valid_user, only: [:edit, :update])

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user
      user.create_reset_token_and_digest
      UserMailer.send_password_reset_mail(user).deliver_now
      flash[:success] = 'パスワード再設定メールを送信しました。'
      redirect_to(root_url)
    else
      @user = User.new(email: params[:user][:email])
      flash[:danger] = 'メールアドレスが間違っています。'
      render('new')
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'パスワードを再設定しました。'
      redirect_to(log_in_url)
    else
      render('edit')
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def valid_user
      @user = User.find_by(id: params[:id])
      unless @user || @user.authenticate?(params[:reset_token], :reset_digest) || @user.activated?
        redirect_to(root_url)
      end
    end
end
