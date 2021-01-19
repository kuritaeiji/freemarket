module SessionsHelper
  def log_in(user)
    cookies.permanent.signed[:user_id] = user.id
    new_session_id_and_digest(user)
  end

  def logged_in?
    !!(current_user && current_user.authenticate?(cookies[:session_id]))
  end

  def current_user
    @current_user ||= User.find_by(id: cookies.signed[:user_id])
  end

  def to_digest(token)
    BCrypt::Password.create(token)
  end

  def new_token
    SecureRandom.urlsafe_base64(24)
  end

  def log_out
    cookies.delete(:user_id)
    cookies.delete(:session_id)
  end

  private
    def new_session_id_and_digest(user)
      session_id = new_token
      session_digest = to_digest(session_id)
      user.update!(session_digest: session_digest)
      cookies.permanent[:session_id] = session_id
    end
end
