class Card < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :rarity, presence: true
  validates :image_url, presence: true
end
