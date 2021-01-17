module ApplicationHelper
  def get_title(title)
    title ? "#{title} フリーマーケット" : 'フリーマーケット'
  end
end
