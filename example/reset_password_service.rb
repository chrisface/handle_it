# frozen_string_literal: true

require "./lib/handle_it/event_registry"
require "./lib/handle_it/callable"

class ResetPasswordService
  extend HandleIt::Callable

  def initialize(password:, password_confirmation:, token:, &event_handler_setup)
    @password = password
    @password_confirmation = password_confirmation
    @token = token

    @registry = HandleIt::EventRegistry.new(
      :password_mismatch,
      :token_not_found,
      :token_expired,
      :success,
      &event_handler_setup
    )
  end

  def call
    return registry.trigger_event(:token_not_found) if @token == "invalidtoken"
    return registry.trigger_event(:token_expired) if @token == "expiredtoken"
    return registry.trigger_event(:password_mismatch, "You idiot") unless password == password_confirmation
    registry.trigger_event(:success)
  end

  private

  attr_accessor :password, :password_confirmation, :token, :registry
end
