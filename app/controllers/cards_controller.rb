class CardsController < ApplicationController
  before_action :authenticate_user!  # Assure que l'utilisateur est authentifié avant toute action

  def index
    cards = current_user.cards
    render json: cards
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
