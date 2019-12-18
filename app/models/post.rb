class Post < ApplicationRecord
  require 'date'

  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, length: { maximum: 500 }
  validates :size, numericality: { only_integer: true }
  validates :weight, numericality: { only_integer: true }
  validates :number, numericality: { only_integer: true }
  validates :date, presence: true
 
end
