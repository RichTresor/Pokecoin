class AuthController < ApplicationController
  include Authentication  # Inclure le module d'authentification

  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:login, :signup]

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last  # Récupère le token d'authentification
    if token
      begin
        decoded_token = JWT.decode(token, Rails.application.config.jwt_secret, true, { algorithm: 'HS256' }).first
        user_id = decoded_token['user_id']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError => e
        Rails.logger.error "Erreur de décodage du token : #{e.message}"
        render json: { error: 'Invalid token' }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "Utilisateur non trouvé pour le token : #{e.message}"
        render json: { error: 'User not found' }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorized: Missing token' }, status: :unauthorized
    end
  end
  
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

  def signup
    user = User.new(user_params)
    if user.save
      token = encode_token(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Email ou mot de passe invalide' }, status: :unauthorized
    end
  end

  def show
    render json: current_user  # current_user est automatiquement défini par l'authentification JWT
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.config.jwt_secret, 'HS256')
  end
end
