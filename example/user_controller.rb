# frozen_string_literal: true

require_relative "reset_password_request_service"
require_relative "reset_password_service"

class UserController
  def reset_password_request(params = {})
    ResetPasswordRequestService.call(email: params[:email])
    puts "We will send password reset information to the email provided if it exists."
  end

  def reset_password(params = {})
    ResetPasswordService.call(
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      token: params[:token]
    ) do |on|
      on.password_mismatch { |message| password_mismatch(message) }
      on.token_not_found { token_not_found }
      on.token_expired { token_expired }
      on.success { success }
    end
  end

  private

  def password_mismatch(message)
    puts "Your passwords did not match: #{message}"
  end

  def token_not_found
    puts "Password reset token was not valid"
  end

  def token_expired
    puts "Your password reset link has expired"
  end

  def success
    puts "Successfully updated your password"
  end
end
