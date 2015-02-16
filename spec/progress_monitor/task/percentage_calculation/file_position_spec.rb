RSpec.describe ProgressMonitor::Task::PercentageCalculation::FilePosition do
  let(:calculator) { described_class.new task }
  let(:task) { instance_double ProgressMonitor::Task, file: file }
  let(:file) { instance_double File, size: file_size, pos: file_pos }
  let(:file_size) { 1000 }
  let(:file_pos) { 200 }

  describe '#perform' do
    subject(:perform) { calculator.perform }

    context 'when file is nil' do
      let(:file) { nil }

      it 'returns nil' do
        expect(perform).to eq nil
      end
    end

    context 'when file size is 0' do
      let(:file_size) { 0 }

      it 'returns nil' do
        expect(perform).to eq nil
      end
    end

    context 'when file size is nonzero' do
      let(:file_size) { 1000 }
      let(:file_pos) { 200 }

      it 'calculates percentage based on file pos' do
        expect(perform).to eq 20
      end
    end

    context 'when an error occurs' do
      before do
        allow(file).to receive(:size).and_raise
      end

      it 'returns :unknown' do
        expect(perform).to eq :unknown
      end
    end
  end
end
