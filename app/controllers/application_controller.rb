class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include Pundit::Authorization
        include Pundit
        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
        private

  def user_not_authorized
    render json: { error: 'Você não tem permissão para executar esta ação.' }, status: :forbidden
  end
end
