class Task < ApplicationRecord
  belongs_to :user
  enum status: { in_progress: 0, done: 1 }
  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: { maximum: 100 }
end
