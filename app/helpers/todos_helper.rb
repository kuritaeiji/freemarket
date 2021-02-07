module TodosHelper
  def todo_alert
    if current_user == @todo.product.sell_user
      content_tag(:div, '発送して下さい。', class: 'alert alert-info') unless @todo.shipped?
    elsif current_user == @todo.product.purchace_user
      purchace_user_alert
    end
  end

  def todo_button
    if current_user == @todo.product.sell_user && !@todo.shipped?
      link_to('発送を通知する', ship_todo_path(@todo), method: :put, class: 'btn btn-danger btn-block btn-lg mb-3')
    elsif current_user == @todo.product.purchace_user && @todo.shipped? && !@todo.received?
      link_to('荷物を受け取りました', receive_todo_path(@todo), method: :put, class: 'btn btn-danger btn-block btn-lg mb-3')
    end
  end

  def todo_body(todo)
    if current_user == todo.product.purchace_user
      purchace_user_body(todo)
    elsif current_user == todo.product.sell_user
      sell_user_body(todo)
    end
  end

  def todo_count
    current_user.not_received_todos.length
  end

  def todo_class
    'present-todo' if todo_count > 0
  end

  private
    def purchace_user_alert
      if !@todo.shipped? # 発送してない時
        content_tag(:div, '出品者にメッセージを送りましょう。', class: 'alert alert-info')
      elsif @todo.shipped? && !@todo.received? # 発送中
        content_tag(:div, '出品者が発送しました。荷物を受け取りましょう。', class: 'alert alert-info')
      end
    end

    def sell_user_body(todo)
      if todo.shipped?
        '出品者とメッセージのやりとりをしましょう。'
      else
        '商品を発送しましょう。'
      end
    end

    def purchace_user_body(todo)
      if todo.shipped?
        '商品を受け取りましょう。'
      else
        '出品者とメッセージのやりとりをしましょう。'
      end
    end
end
