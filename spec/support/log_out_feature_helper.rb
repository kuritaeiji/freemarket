module LogOutFeatureHelper
  def log_out_feature(user)
    visit(user_path(user))
    click_on('ログアウト')
  end
end