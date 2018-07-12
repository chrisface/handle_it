# frozen_string_literal: true

module HandleIt
  class EventRegistry
    CallingUnknownEvent = Class.new(RuntimeError)
    InvalidEventHandlers = Class.new(RuntimeError)

    attr_accessor :event_handlers

    def initialize(*event_names, &event_handler_setup)
      @event_names = event_names
      @event_handlers = {}

      record_handlers(event_handler_setup)
      validate_handlers!
    end

    def trigger_event(event_name, *args)
      raise CallingUnknownEvent unless @event_handlers[event_name]

      @event_handlers[event_name].call(*args)
    end

    private

    def record_handlers(event_handler_setup)
      event_handler_setup&.call(self)
    end

    def validate_handlers!
      unhandled_events = (@event_names - @event_handlers.keys).sort
      unknown_events = (@event_handlers.keys - @event_names).sort

      message = []

      unless unhandled_events.empty?
        message << "You forgot to handle these events:"
        unhandled_events.each { |event| message << "  - #{event}" }
      end

      unless unknown_events.empty?
        message << "" if unhandled_events.any?
        message << "You gave handlers to these unknown events:"
        unknown_events.each { |event| message << "  - #{event}" }
      end

      unless message.empty?
        raise InvalidEventHandlers, message.join("\n")
      end
    end

    def method_missing(event_name, &block)
      register_event(event_name, &block)
    end

    def register_event(event_name, &block)
      @event_handlers[event_name] = block
    end
  end
end
