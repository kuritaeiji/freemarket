module LogInRequestHelper
  def log_in_request(user)
    post('/log_in', params: { user: { email: user.email, password: user.password } })
  end
end