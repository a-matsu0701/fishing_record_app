class Post < ApplicationRecord
  has_one_attached :image

  validate :image_presence
  validates :title, presence: true, length: { maximum: 50 }
  validates :date, presence: true
  validates :size, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :weight, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :number, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :comment, length: { maximum: 500 }

  def image_presence
    if image.attached?
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:image, 'にはjpegまたはpngファイルを添付してください')
      end
    else
      errors.add(:image, 'ファイルを添付してください')
    end
  end

end
