class CardsController < ApplicationController
  before_action :authenticate_user!  # Assure que l'utilisateur est authentifié avant toute action

  def index
    # Récupère les cartes "à vendre" de l'utilisateur ou sans propriétaire
    cards = Card.where(state: 'à vendre').where('user_id IS NULL OR user_id != ?', current_user.id)
    
    # Récupère aussi les cartes appartenant à l'utilisateur (peu importe leur état)
    user_cards = current_user.cards
    
    # Combine les cartes à vendre et les cartes de l'utilisateur
    combined_cards = cards + user_cards
    
    render json: combined_cards.uniq  # Utilise uniq pour éviter les doublons dans le tableau des cartes
  end
  
  

  def show
    card = current_user.cards.find(params[:id])
    render json: card
  end

  def update
    @card = current_user.cards.find(params[:id])
    
    if @card.update(card_params)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  def create
    card = current_user.cards.build(card_params)  # L'utilisateur crée une carte qui lui appartient
    
    if card.save
      render json: card, status: :created
    else
      render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def buy
    # Récupérer la carte que l'utilisateur veut acheter
    card = Card.find(params[:id])

    # Vérifier si la carte est "à vendre" et si l'utilisateur n'est pas déjà le propriétaire
    if card.state == 'à vendre'
      # Si la carte n'a pas de propriétaire (user_id == nil), on permet l'achat
      if card.user_id.nil?
        seller = User.find_by(id: card.user_id)  # Pas nécessaire car user_id est nil, donc on ne le trouve pas ici
      else
        seller = User.find(card.user_id)  # Trouver le vendeur existant
      end

      amount = card.last_price  # Le montant de la transaction est le prix de la carte

      # L'acheteur effectue la transaction
      if current_user.balance >= amount
        # Créer une transaction
        transaction = Transaction.create!(
          buyer_id: current_user.id,
          seller_id: seller&.id,  # Utilise seller&.id pour éviter les erreurs si seller est nil
          card_id: card.id,
          amount: amount,
          transaction_date: Time.now
        )

        # Mettre à jour les soldes des utilisateurs
        current_user.update!(balance: current_user.balance - amount)  # Débiter l'acheteur
        seller.update!(balance: seller.balance + amount) if seller  # Créditer le vendeur s'il existe

        # Mettre à jour la carte avec le nouvel propriétaire
        card.update!(user_id: current_user.id, state: 'non à vendre')  # L'acheteur devient le propriétaire

        render json: { message: 'Achat réussi', transaction: transaction }, status: :ok
      else
        render json: { error: 'Solde insuffisant' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Cette carte ne peut pas être achetée.' }, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(:name, :rarity, :image_url, :last_price, :user_id, :state)
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.debug "Token reçu : #{token}"
    if token
      begin
        # Utilise la clé secrète correcte pour vérifier le token (la même utilisée dans encode_token)
        decoded_token = JWT.decode(token, Rails.application.config.jwt_secret, true, { algorithm: 'HS256' }).first
        user_id = decoded_token['user_id']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError => e
        Rails.logger.error "Erreur de décodage du token : #{e.message}"
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  
end
