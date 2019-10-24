class Unauthorized < StandardError; end

module ApiTokenAuthorizable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user

    before_action :authenticate_user

    rescue_from Unauthorized, with: -> { render json: { error: 'Unauthorized request' }, status: 401 }
  end

  private

  def authenticate_user
    @current_user = AuthenticationService.call(request.headers).data
    raise Unauthorized unless @current_user
  end
end
