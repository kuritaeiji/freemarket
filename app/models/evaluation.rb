class Evaluation < ApplicationRecord
  include(Noticeable)
  belongs_to(:product)

  validates(:score, presence: true ,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 })

  after_create_commit do
    notices.create(send_user: purchaced_product.purchace_user, receive_user: purchaced_product.sell_user)
  end

  def notice_path
    '#'
  end

  def notice_body
    "#{purchaced_product.purchace_user.account_name}が#{purchaced_product.name}に「#{score_text}」と評価しました。"
  end

  def notice_image
    purchaced_product.images[0]
  end

  private
    def score_text
      if score == 1
        '悪い'
      elsif score == 2
        '普通'
      else
        '良い'
      end
    end
end