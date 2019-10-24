# frozen_string_literal: true

class UsersController < Devise::RegistrationsController
  respond_to :json

	private

  def sign_up_params
    params.require(:sign_up).permit(:email, :password)
  end
end
