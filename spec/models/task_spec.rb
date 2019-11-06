require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#is_valid?' do
    it { expect(build(:task)).to be_valid }
    it { expect(build(:task, title: nil)).to_not be_valid }
    it { expect(build(:task, title: '1' * 101)).to_not be_valid }
  end
end
