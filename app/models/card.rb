class Card < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :rarity, presence: true
  validates :image_url, presence: true
  # On peut ajouter des validations si nécessaire, par exemple vérifier si l'état de la carte est "à vendre"
  validates :state, inclusion: { in: ['non à vendre', 'à vendre'] }

end
