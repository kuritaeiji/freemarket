module ApplicationHelper
  def get_title(title)
    title ? "#{title} フリーマーケット" : 'フリーマーケット'
  end

  def messageable_post_url
    messageable_type = controller.controller_name.singularize
    messages_path(messageable_type: messageable_type.capitalize, 
      messageable_id: controller.instance_variable_get("@#{messageable_type}").id)
  end

  def messageable_delete_url(message)
    message_path(message.id, messageable_type: message.messageable.class.to_s, messageable_id: message.messageable.id)
  end

  def notice_link
    if current_user.receive_notices.count > 0

    else
     
    end
  end
end
