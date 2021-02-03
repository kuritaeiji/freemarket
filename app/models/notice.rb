class Notice < ApplicationRecord
  belongs_to(:send_user, class_name: 'User')
  belongs_to(:receive_user, class_name: 'User')
  belongs_to(:noticeable, polymorphic: true)

  delegate(:notice_image, :notice_path, :notice_body, to: :noticeable)
end
