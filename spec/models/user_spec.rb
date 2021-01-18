require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:prefecture) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(50) }
  it('メールアドレスは正しいフォーマット') do
    email = 'ffff.com'
    user = build(:user, email: email)
    user.valid?
    expect(user.errors[:email][0]).to eq('は不正な値です')
  end

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_most(20) }
  it('パスワードは大文字、小文字、数字全て含む') do
    password = 'password1010'
    user = build(:user, password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password][0]).to eq('は不正な値です')
  end

  it { is_expected.to validate_presence_of(:account_name) }
  it { is_expected.to validate_length_of(:account_name).is_at_most(20) }

  it { is_expected.to validate_presence_of(:family_name) }
  it { is_expected.to validate_length_of(:family_name).is_at_most(20) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(20) }

  it { is_expected.to validate_presence_of(:postal_code) }

  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_length_of(:address).is_at_most(50) }

  it { is_expected.to validate_presence_of(:prefecture_id) }
  it { is_expected.to validate_numericality_of(:prefecture_id).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:prefecture_id).is_less_than_or_equal_to(47) }

  it { is_expected.to have_secure_password }

  it('デフォルトスコープがID順') do
    user1 = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    expect(User.all).to eq([user1, user2, user3])
  end
end
