module MessagesHelper
  def message_date_time(message)
    if message.created_at.today?
      l(message.created_at, format: :short)
    elsif message.created_at.year == Time.current.year
      l(message.created_at)
    else
      l(message.created_at, format: :long)
    end
  end
end
