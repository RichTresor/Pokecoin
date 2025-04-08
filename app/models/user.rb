class User < ApplicationRecord
    has_secure_password
    has_many :transactions_as_buyer, class_name: 'Transaction', foreign_key: 'buyer_id'
    has_many :transactions_as_seller, class_name: 'Transaction', foreign_key: 'seller_id'
  
    # Validations
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
    validates :balance, numericality: { greater_than_or_equal_to: 0 }  # Le solde ne peut pas être négatif
  
    # Callback
    before_create :set_default_balance
  
    private
  
    def set_default_balance
      self.balance ||= 0.0
    end
    has_many :cards
     # Exemple de méthode pour effectuer une transaction
    def make_transaction(seller, card, amount)
      # Vérifier si l'acheteur a assez de solde
      if self.balance >= amount
        # Créer une transaction
        transaction = Transaction.create!(
          buyer_id: self.id,
          seller_id: seller.id,
          card_id: card.id,
          amount: amount
        )

        # Mettre à jour le solde de l'acheteur et du vendeur
        self.update!(balance: self.balance - amount)  # Débiter l'acheteur
        seller.update!(balance: seller.balance + amount)  # Crédits le vendeur

        # Mettre à jour la carte avec le nouvel propriétaire
        card.update!(user_id: self.id, state: 'non à vendre')  # L'acheteur devient le propriétaire

        transaction  # Retourne l'objet transaction
      else
        raise "Solde insuffisant"
      end
    end
  end
  