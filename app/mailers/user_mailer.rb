class UserMailer < ApplicationMailer
  def send_account_activation_mail(user)
    @user = user
    mail(to: @user.email, subject: 'アカウント有効化')
  end

  def send_password_reset_mail(user)
    @user = user
    mail(to: @user.email, subject: 'パスワード再設定')
  end
end
