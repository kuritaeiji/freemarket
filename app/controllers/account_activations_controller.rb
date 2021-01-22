class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(id: params[:user_id])
    if user && !user.activated? && user.authenticate?(params[:activation_token], :activation_digest)
      user.update(activated: true)
      log_in(user)
      flash[:success] = 'アカウントを有効化し、ログインしました。'
      binding.pr
      redirect_to(root_url)
    else
      flash[:danger] = 'すでにアカウントが有効化されているか、無効なリンクです。'
      redirect_to(root_url)
    end
  end
end
