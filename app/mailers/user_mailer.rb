class UserMailer < ApplicationMailer
  def send_account_activation_mail(user)
    @user = user
    mail(to: @user.email, subject: 'アカウント有効化')
  end
end
