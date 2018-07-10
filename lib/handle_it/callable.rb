module HandleIt
  module Callable
    def call(*args, &block)
      new(*args, &block).call
    end
  end
end
