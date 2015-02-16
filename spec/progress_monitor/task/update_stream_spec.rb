RSpec.describe ProgressMonitor::Task::UpdateStream do
  subject(:update_stream) { described_class.new }

  it 'includes Observable' do
    expect(described_class.ancestors).to include Observable
  end

  describe '#notify' do
    subject(:notify) { update_stream.notify task, event, details }
    let(:task) { double 'task' }
    let(:event) { double 'event' }
    let(:details) { double 'details' }
    before do
      allow(update_stream).to receive(:changed)
      allow(update_stream).to receive(:notify_observers)
    end

    it 'calls changed' do
      expect(update_stream).to receive(:changed)
      notify
    end

    it 'calls notify_observers with arguments' do
      expect(update_stream).to receive(:notify_observers).with(task, event, details)
      notify
    end
  end
end
