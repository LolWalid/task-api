require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#is_valid?' do
    it { expect(build(:user)).to be_valid }

    it { expect(build(:user, password: nil)).to_not be_valid }
    it { expect(build(:user, email: 'not_an_email')).to_not be_valid }
    it { expect(build(:user, email: '')).to_not be_valid }

    it 'is not valid when email is already taken' do
      user = create(:user)
      expect(build(:user, email: user.email)).to_not be_valid
    end
  end
end
