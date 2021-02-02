module PurchacedProductsHelper
  def todo_alert(p_p)
    if current_user == p_p.sell_user
      content_tag(:div, '発送して下さい。', class: 'alert alert-info') unless p_p.shipped?
    else
      content_tag(:div, purchace_user_text(p_p), class: 'alert alert-info')
    end
  end

  private
    def purchace_user_text(p_p)
      if !p_p.shipped? # 発送していない時
        '出品者にメッセージを送りましょう。'
      elsif p_p.shipped? && !p_p.received? # 発送中
        '出品者が発送しました。荷物を受け取りましょう。'
      end
    end
end
