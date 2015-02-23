RSpec.describe ProgressMonitor::Task::PercentageCalculation do
  subject(:percentage_calculation) { described_class.new task }
  let(:task) { instance_double ProgressMonitor::Task }

  let(:calculators) { ProgressMonitor::Task::PercentageCalculation::PERCENTAGE_CALCULATORS }

  describe '#perform' do
    subject(:perform) { percentage_calculation.perform }
    let(:calculator_result) { 15 }
    before do
      calculators.each do |calculator_class|
        allow(calculator_class).to receive(:perform) { calculator_result }
      end
    end

    it 'performs calculation for task' do
      expect(calculators.first).to receive(:perform).with(task)
      perform
    end

    context 'when a calculator returns a result' do
      let(:calculator_result) { 15 }

      it 'returns result from calculator' do
        expect(perform).to eq calculator_result
      end
    end

    context 'when no calculator returns a result' do
      let(:calculator_result) { nil }

      it 'returns :unknown' do
        expect(perform).to eq :unknown
      end
    end

    context 'when an error occurs' do
      let(:e) { StandardError.new }
      before do
        allow(calculators.first).to receive(:perform).and_raise(e)
        allow(percentage_calculation).to receive(:puts)
      end

      it 'puts error' do
        expect(percentage_calculation).to receive(:puts).with(e.inspect)
        perform
      end

      it 'returns :unknown' do
        expect(perform).to eq :unknown
      end
    end
  end
end
