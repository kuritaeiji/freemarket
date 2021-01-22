class OauthController < ApplicationController
  def authorization
    client = OAuth2::Client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
      site: 'https://accounts.google.com/', authorize_url: 'o/oauth2/auth')
    scopes = ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email']
    redirect_to(client.auth_code.authorize_url(redirect_uri: 'http://localhost:3000/oauth/callback',
      scope: scopes.join(' ')))
  end

  def callback
    token = get_token_client.auth_code.get_token(
      params[:code],
      redirect_uri: 'http://localhost:3000/oauth/callback'
    )

    response = token.get('https://www.googleapis.com/oauth2/v1/userinfo')

    @user_info = JSON.parse(response.body)
    user = User.find_by(uid: @user_info['id'])
    if user
      log_in(user)
      flash[:success] = 'ログインしました。'
      redirect_to(root_url)
    end
    @prefectures = Prefecture.all
    @user = User.new
  end

  private
    def get_token_client
      OAuth2::Client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
        site: 'https://accounts.google.com/', token_url: 'o/oauth2/token')
    end
end