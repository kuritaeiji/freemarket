FactoryBot.define do
  factory(:purchaced_product_message, class: 'Message') do
    association(:user)
    association(:messageable, factory: :purchaced_product)
    content { 'test message' }
  end
end
