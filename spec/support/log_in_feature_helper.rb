module LogInFeatureHelper
  def log_in_feature(user)
    visit(log_in_path)
    fill_in('メールアドレス', with: user.email)
    fill_in('パスワード', with: user.password)
    within('.log-in-form') do
      click_on('ログイン')
    end
  end
end