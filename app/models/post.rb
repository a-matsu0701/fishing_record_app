class Post < ApplicationRecord
  require 'date'

  validates :title, presence: true, length: { maximum: 50 }
  validates :date, presence: true
  validates :size, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :weight, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :number, numericality: { only_integer: true, greater_than: 0 }, :allow_blank => true
  validates :comment, length: { maximum: 500 }

end
