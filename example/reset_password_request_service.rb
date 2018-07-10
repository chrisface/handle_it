# frozen_string_literal: true

require "./lib/handle_it/event_registry"
require "./lib/handle_it/callable"

class ResetPasswordRequestService
  extend HandleIt::Callable

  def initialize(email:)
    @email = email
  end

  def call
    user&.update_attributes(
      password_reset_token: "a new token",
      password_reset_token_created_at: Time.now.utc
    )
  end

  private

  def user
    nil
  end

  attr_accessor :email
end
