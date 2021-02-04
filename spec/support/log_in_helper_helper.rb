module LogInHelperHelper
  include(SessionsHelper)

  def log_in_helper(user)
    development_cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
    development_cookies.signed[:user_id] = user.id.to_s 
    helper.request.cookies[:user_id] = development_cookies[:user_id]

    session_id = new_token
    user.update(session_digest: to_digest(session_id))
    helper.request.cookies[:session_id] = session_id
  end
end