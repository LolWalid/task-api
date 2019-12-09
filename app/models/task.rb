class Task < ApplicationRecord
  include Tokenable

  belongs_to :user
  enum status: { in_progress: 0, done: 1 }
  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: { maximum: 100 }

  def to_jbuilder
    {
      id: token,
      title: title,
      description: description,
      due_date: due_date
    }
  end

  def image_json
    return {} unless image?

    {
      url: image&.url,
      width: image&.width,
      height: image&.height
    }
  end
end
