FactoryBot.define do
  factory(:todo_message, class: 'Message') do
    association(:user)
    association(:messageable, factory: :todo)
    content { 'test message' }
  end
end
