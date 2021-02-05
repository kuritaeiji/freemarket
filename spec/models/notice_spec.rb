require 'rails_helper'

RSpec.describe Notice, type: :model do
  it { is_expected.to belong_to(:send_user).class_name('User') }
  it { is_expected.to belong_to(:receive_user).class_name('User') }
  it { is_expected.to belong_to(:noticeable) }
  
  it { is_expected.to delegate_method(:notice_body).to(:noticeable) }
  it { is_expected.to delegate_method(:notice_path).to(:noticeable) }
  it { is_expected.to delegate_method(:notice_image).to(:noticeable) }
end
