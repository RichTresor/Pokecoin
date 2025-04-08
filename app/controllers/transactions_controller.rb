class TransactionsController < ApplicationController
    include Authentication  # Inclure le module d'authentification
  
    before_action :authenticate_user!, only: [:index]
  
    def index
      # Récupérer toutes les transactions pour l'utilisateur authentifié
      transactions = Transaction.where('buyer_id = ? OR seller_id = ?', current_user.id, current_user.id)
  
      # Ajouter le nom du vendeur, le nom de la carte et "Admin" si seller_id est nil
      transactions = transactions.map do |transaction|
        # Ajouter le nom du vendeur
        if transaction.seller_id.nil?
          seller_name = 'Admin'
        else
          seller = User.find(transaction.seller_id)
          seller_name = seller.username
        end
  
        # Ajouter le nom de la carte liée à cette transaction
        card = Card.find(transaction.card_id)  # Récupérer la carte via card_id
        card_name = card.name  # Récupérer le nom de la carte
  
        # Ajouter seller_name et card_name à la transaction
        transaction = transaction.attributes.merge('seller_name' => seller_name, 'card_name' => card_name)
      end
  
      render json: transactions
    end
  end
  