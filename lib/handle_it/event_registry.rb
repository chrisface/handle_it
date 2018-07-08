# frozen_string_literal: true

module HandleIt
  class EventRegistry
    CallingUnknownEvent = Class.new(RuntimeError)
    MissingEventHandler = Class.new(RuntimeError)

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
      return if @event_names.sort == @event_handlers.keys.sort
      raise(
        MissingEventHandler,
        "Events missing handlers: #{@event_names - @event_handlers.keys}"
      )
    end

    def method_missing(event_name, &block)
      if respond_to_missing?(event_name)
        register_event(event_name, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_all = false)
      @event_names.include?(method_name) || super
    end

    def register_event(event_name, &block)
      @event_handlers[event_name] = block
    end
  end
end
