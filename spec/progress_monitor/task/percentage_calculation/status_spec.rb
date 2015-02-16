RSpec.describe ProgressMonitor::Task::PercentageCalculation::Status do
  let(:calculator) { described_class.new task }
  let(:task) { instance_double ProgressMonitor::Task, status: task_status }

  describe '#perform' do
    subject(:perform) { calculator.perform }

    context 'when task status is :new' do
      let(:task_status) { :new }

      it 'returns 0' do
        expect(perform).to eq 0
      end
    end

    context 'when task status is :finished' do
      let(:task_status) { :finished }

      it 'returns 100' do
        expect(perform).to eq 100
      end
    end

    context 'when task status is something else' do
      let(:task_status) { :foo }

      it 'returns nil' do
        expect(perform).to eq nil
      end
    end
  end
end
