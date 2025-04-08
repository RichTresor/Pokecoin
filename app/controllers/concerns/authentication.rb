# app/controllers/concerns/authentication.rb
module Authentication
    extend ActiveSupport::Concern
  
    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last  # Récupère le token JWT dans les en-têtes
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
  
    def current_user
      @current_user  # Utilise @current_user qui est défini dans authenticate_user!
    end
  end
  