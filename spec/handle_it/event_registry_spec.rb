RSpec.describe HandleIt::EventRegistry do
  describe "#initialize" do
    let(:event_handler) do
      Proc.new {}.tap do |proc|
        allow(proc).to receive(:call)
      end
    end

    it "records event handlers" do
      registry = described_class.new(:event) do |on|
        on.event(&event_handler)
      end

      expect(registry.event_handlers).to eq(
        event: event_handler
      )
    end

    it "calls events" do
      registry = described_class.new(:event) do |on|
        on.event(&event_handler)
      end

      registry.trigger_event(:event)
      expect(event_handler).to have_received(:call)
    end

    it "calls events with arguments" do
      registry = described_class.new(:event) do |on|
        on.event(&event_handler)
      end

      block = Proc.new {}

      registry.trigger_event(:event, :arg, some: :kwargs, &block)
      expect(event_handler).to have_received(:call).with(:arg, some: :kwargs, &block)
    end

    it "raises when an event has no handler" do
      expect do
        described_class.new(:event)
      end.to raise_error(HandleIt::EventRegistry::MissingEventHandler)
    end

    it "raises when attempting to handle an unknown event" do
      expect do
        described_class.new(:event) do |on|
          on.event(&event_handler)
          on.unknown_event(&event_handler)
        end
      end.to raise_error(NoMethodError)
    end
  end
end
