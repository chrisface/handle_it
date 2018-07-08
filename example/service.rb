# frozen_string_literal: true

require "./lib/handle_it/event_registry"

class Service
  def self.create_user(user_info, &event_handler_setup)
    registry = HandleIt::EventRegistry.new(
      :success,
      :lied_about_age,
      :validation_error,
      :catastrophic_failure,
      &event_handler_setup
    )

    if user_info[:age] > 130
      registry.trigger_event(:lied_about_age, user_info[:age])
    elsif user_info[:age].negative?
      registry.trigger_event(:validation_error, ["Age can not be a negative number"])
    elsif (Random.rand(5) == 1)
      registry.trigger_event(:catastrophic_failure)
    else
      registry.trigger_event(:success)
    end
  end
end
