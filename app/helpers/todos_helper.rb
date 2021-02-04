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
      link_to('発送を通知する', ship_todo_path(@todo), method: :put, class: 'btn btn-danger btn-block btn-lg')
    elsif current_user == @todo.product.purchace_user && @todo.shipped? && !@todo.received?
      link_to('荷物を受け取りました', receive_todo_path(@todo), method: :put, class: 'btn btn-danger btn-block btn-lg')
    end
  end

  private
    def purchace_user_alert
      if !@todo.shipped? # 発送してない時
        content_tag(:div, '出品者にメッセージを送りましょう。', class: 'alert alert-info')
      elsif @todo.shipped? && !@todo.received? # 発送中
        content_tag(:div, '出品者が発送しました。荷物を受け取りましょう。', class: 'alert alert-info')
      end
    end
end
