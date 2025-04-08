class TransactionsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      # Récupérer les transactions liées à l'utilisateur
      transactions = Transaction.where('buyer_id = ? OR seller_id = ?', current_user.id, current_user.id)
  
      # Formatage des transactions pour inclure le nom du vendeur ou "Admin" si seller_id est null
      transactions = transactions.map do |transaction|
        if transaction.seller_id.nil?
          transaction.seller_name = 'Admin'
        else
          transaction.seller_name = User.find(transaction.seller_id).username
        end
        transaction
      end
  
      render json: transactions
    end
  end
  