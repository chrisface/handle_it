RSpec.describe HandleIt::EventRegistry do
  let(:event_handler) do
    Proc.new {}.tap do |proc|
      allow(proc).to receive(:call)
    end
  end

  describe "#initialize" do
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

    it "raises when attempting to handle an unknown event" do
    end
  end

  describe "errors when handling events" do
    context "forgot to handle event" do
      it "raises a helpful error" do
        expect do
          described_class.new(:event) { |on| }
        end.to raise_error(
          HandleIt::EventRegistry::InvalidEventHandlers,
          <<~EOS.chomp
            You forgot to handle these events:
              - event
          EOS
        )
      end
    end

    context "handling unknown events" do
      it "raises a helpful error" do
        expect do
          described_class.new(:event) do |on|
            on.event(&event_handler)
            on.unknown_event(&event_handler)
          end
        end.to raise_error(
          HandleIt::EventRegistry::InvalidEventHandlers,
          <<~EOS.chomp
            You gave handlers to these unknown events:
              - unknown_event
          EOS
        )
      end
    end

    context "both missing and unknown events" do
      it "raises a helpful error" do
        expect do
          described_class.new(:event) do |on|
            on.unknown_event(&event_handler)
          end
        end.to raise_error(
          HandleIt::EventRegistry::InvalidEventHandlers,
          <<~EOS.chomp
            You forgot to handle these events:
              - event

            You gave handlers to these unknown events:
              - unknown_event
          EOS
        )
      end
    end
  end
end
