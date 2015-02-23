RSpec.describe ProgressMonitor::Display do
  let(:display) { described_class.new task }
  let(:task) { instance_double ProgressMonitor::Task }
  let(:queue) { instance_double ::Queue }
  before do
    allow(::Queue).to receive(:new) { queue }
  end

  describe '#initialize' do
    it 'creates a queue' do
      expect(Queue).to receive(:new)
      display
    end
  end

  describe '#show' do
    subject(:show) { display.show }
    let(:multi_line_renderer) { instance_double ProgressMonitor::Display::MultiLineRenderer, refresh: nil }
    let(:input_loop) { instance_double ProgressMonitor::Display::InputLoop, perform: nil }
    let(:timer_loop) { instance_double ProgressMonitor::Display::TimerLoop, perform: nil }
    let(:message_loop) { instance_double ProgressMonitor::Display::MessageLoop, perform: nil }
    let(:io_loop) { instance_double ProgressMonitor::Display::IoLoop, perform: nil }
    before do
      allow(Thread).to receive(:new).and_yield
      allow(ProgressMonitor::Display::MultiLineRenderer).to receive(:new) { multi_line_renderer }
      allow(ProgressMonitor::Display::InputLoop).to receive(:new) { input_loop }
      allow(ProgressMonitor::Display::TimerLoop).to receive(:new) { timer_loop }
      allow(ProgressMonitor::Display::MessageLoop).to receive(:new) { message_loop }
      allow(ProgressMonitor::Display::IoLoop).to receive(:new) { io_loop }
      allow(display).to receive(:stdout=)
    end

  end
end
