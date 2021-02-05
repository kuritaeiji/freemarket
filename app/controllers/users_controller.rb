class UsersController < ApplicationController
  before_action(:oauth_user, only: [:oauth])
  before_action(:log_in_user, only: [:edit, :update, :destroy, :edit_address, :update_address])
  before_action(:set_user, only: [:show, :edit, :update, :destroy, :edit_address, :update_address])
  before_action(:correct_user, only: [:edit, :update, :destroy, :edit_address, :update_address])
  before_action(:not_have_trading_products, only: [:destroy])

  def show
    @untraded_products = @user.products.where(traded: false).paginate(page: params[:page], per_page: 30)
  end

  def new
    @user = User.new
    @prefectures = Prefecture.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.send_account_activation_mail(self).deliver_now
      flash[:success] = 'メールを確認してアカウントを有効化してください。'
      redirect_to(root_path)
    else
      @prefectures = Prefecture.all
      render('new')
    end
  end

  def edit
    set_referer_to_session
  end

  def update
    if @user.update(update_user_params)
      flash[:success] = 'プロフィールを更新しました。'
      redirect_referer_or(@user)
    else
      render('edit')
    end
  end

  def destroy
    @user.destroy
    flash[:success] = '退会しました。'
    redirect_to(root_url)
  end

  def edit_address
    @prefectures = Prefecture.all
    set_referer_to_session
  end

  def update_address
    if @user.update(update_user_address_params)
      flash[:success] = '住所を変更しました。'
      redirect_referer_or(@user)
    else
      @prefectures = Prefecture.all
      render('edit_address')
    end
  end

  def oauth
    @user = User.new(oauth_user_params)
    if @user.save
      flash[:success] = 'ユーザーを作成しました。'
      log_in(@user)
      redirect_to(root_url)
    else
      @prefectures = Prefecture.all
      @user_info = { 'id' => params[:user][:uid], 'email' => params[:user][:email], 'name' => params[:user][:account_name] }
      render('oauth/callback')
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :account_name,
        :family_name, :first_name, :postal_code, :prefecture_id, :address, :image)
    end

    def update_user_params
      params.require(:user).permit(:account_name, :image)
    end

    def update_user_address_params
      params.require(:user).permit(:family_name, :first_name, :postal_code, :prefecture_id, :address)
    end

    def oauth_user_params
      false_password = ENV['OAUTH_FALSE_PASSWORD']
      params.require(:user).permit(:email, :password, :password_confirmation, :account_name, :family_name,
        :first_name, :postal_code, :prefecture_id, :address, :image, :uid).merge(
          activated: true, password: false_password, password_confirmation: false_password)
    end

    def oauth_user
      unless params[:user][:uid]
        redirect_to(root_url)
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      unless @user == current_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def not_have_traded_products
      if @user.products.where(traded: true, solded: false)
        flash[:danger] = '取引中の商品が存在するのでアカウントを削除できません。'
        redirect_to(root_url)
      end
    end
end
