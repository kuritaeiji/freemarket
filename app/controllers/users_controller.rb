class UsersController < ApplicationController
  before_action(:oauth_user, only: [:oauth])
  before_action(:log_in_user, only: [:show, :edit, :update, :destroy, :edit_address, :update_address])

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @prefectures = Prefecture.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'メールを確認してアカウントを有効化してください。'
      redirect_to(root_path)
    else
      @prefectures = Prefecture.all
      render('new')
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def edit_address
  end

  def update_address
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
end
