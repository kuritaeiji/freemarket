class Notice < ApplicationRecord
  belongs_to(:send_user, class_name: 'User')
  belongs_to(:receive_user, class_name: 'User')
  belongs_to(:noticeable, polymorphic: true)
end
