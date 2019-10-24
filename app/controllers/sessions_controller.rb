# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authorize_user

  respond_to :json

  def create
    generate_new_token = NewSessionService.call(*sessions_params.values)

    if generate_new_token.success?
      render json: { token: generate_new_token.data }
    else
      render json: { error: generate_new_token.errors }, status: :unauthorized
    end
  end

  private

  def sessions_params
    params.require(:sign_in).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :ok
  end
end
