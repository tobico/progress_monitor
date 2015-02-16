RSpec.describe ProgressMonitor::Task::PercentageCalculation::AverageCompletionOfSubtasks do
  let(:calculator) { described_class.new task }
  let(:task) { instance_double ProgressMonitor::Task, subtasks: subtasks }
  
  describe '#perform' do
    subject(:perform) { calculator.perform }

    context 'when no subtasks' do
      let(:subtasks) { [] }

      it 'returns nil' do
        expect(perform).to eq nil
      end
    end

    context 'when multiple subtasks' do
      let(:subtasks) { [subtask1, subtask2] }
      let(:subtask1) { instance_double ProgressMonitor::Task, completion_percent: 25 }
      let(:subtask2) { instance_double ProgressMonitor::Task, completion_percent: 75 }

      it 'returns the average of the completion percent of all tasks' do
        expect(perform).to eq 50
      end
    end

    context 'when an error occurs' do
      let(:subtasks) { [subtask] }
      let(:subtask) { instance_double ProgressMonitor::Task }
      before do
        allow(subtask).to receive(:completion_percent).and_raise
      end

      it 'returns :unknown' do
        expect(perform).to eq :unknown
      end
    end
  end
end
