class UsersController < ApplicationController
  def show
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

  def address_edit
  end

  def address_update
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :account_name,
        :family_name, :first_name, :postal_code, :prefecture_id, :address, :image)
    end
end
