RSpec.describe ProgressMonitor::Task do
  let!(:task) { described_class.new name, update_stream }
  let(:update_stream) { instance_double ProgressMonitor::Task::UpdateStream, notify: nil }
  let(:name) { "test task" }
  let(:parent) { described_class.new "parent" }

  describe '#add_subtask' do
    subject(:add_subtask) { task.add_subtask subtask_name }
    let(:subtask_name) { "test subtask" }
    let(:new_task) { instance_double ProgressMonitor::Task }
    before do
      allow(ProgressMonitor::Task).to receive(:new) { new_task }
    end

    it 'creates a new task' do
      expect(ProgressMonitor::Task).to receive(:new).with(subtask_name, update_stream)
      add_subtask
    end

    it 'adds new task to subtasks' do
      add_subtask
      expect(task.subtasks).to include new_task
    end

    it 'returns new task' do
      expect(add_subtask).to eq new_task
    end
  end

  describe '#add_subtasks' do
    subject(:add_subtasks) { task.add_subtasks *names }
    let(:names) { ["one", "two"] }
    let(:task_one) { instance_double described_class }
    let(:task_two) { instance_double described_class }
    before do
      allow(task).to receive(:add_subtask).with(names[0]) { task_one }
      allow(task).to receive(:add_subtask).with(names[1]) { task_two }
    end

    it 'generates tasks for each name' do
      names.each do |name|
        expect(task).to receive(:add_subtask).with(name)
      end
      add_subtasks
    end

    it 'returns generated tasks' do
      expect(add_subtasks).to eq [task_one, task_two]
    end
  end
  
  describe '#add_and_run_subtasks' do
    subject(:add_and_run_subtasks) { task.add_and_run_subtasks items, name_fn, &run_fn }
    let(:items) { [item] }
    let(:item) { double 'item' }
    let(:name_fn) { Proc.new{|x| @name_arg = x; name} }
    let(:name) { "my task 1" }
    let(:run_fn) { Proc.new{|x| @run_arg = x } }
    before do
      allow(task).to receive(:add_subtask)
    end

    it 'calls name function with item' do
      add_and_run_subtasks
      expect(@name_arg).to eq item
    end

    it 'adds subtask with name derived from name function' do
      expect(task).to receive(:add_subtask).with(name)
      add_and_run_subtasks
    end

    it 'calls run function with item' do
      add_and_run_subtasks
      expect(@run_arg).to eq item
    end
  end

  describe '#start' do
    subject(:start) { task.start }

    it 'notifies update stream of status change' do
      expect(update_stream).to receive(:notify).with(task, :status_change, {from: :new, to: :started})
      start
    end

    it 'sets status to started' do
      start
      expect(task.status).to eq :started
    end

    it 'sets started_at for task' do
      Timecop.freeze
      time = Time.now
      start
      expect(task.started_at).to eq time
    end
  end

  describe '#finish' do
    subject(:finish) { task.finish }
    before do
      task.start
    end

    it 'notifies update stream of status change' do
      expect(update_stream).to receive(:notify).with(task, :status_change, {from: :started, to: :finished})
      finish
    end

    it 'sets status to finished' do
      finish
      expect(task.status).to eq :finished
    end

    it 'sets finished_at for task' do
      Timecop.freeze
      time = Time.now
      finish
      expect(task.finished_at).to eq time
    end
  end

  describe '#info' do
    subject(:info) { task.info message }
    let(:message) { "hello there you" }

    it 'notifies the update stream' do
      expect(update_stream).to receive(:notify).with(task, :info, message: message)
      info
    end
  end
  
  describe '#completion_percent' do
    subject(:completion_percent) { task.completion_percent }
    let(:percentage_calculation) { instance_double ProgressMonitor::Task::PercentageCalculation, perform: result }
    let(:result) { 12 }
    before do
      allow(ProgressMonitor::Task::PercentageCalculation).to receive(:new) { percentage_calculation }
    end

    it 'constructs percentage calculation for task' do
      expect(ProgressMonitor::Task::PercentageCalculation).to receive(:new).with(task)
      completion_percent
    end

    it 'returns result' do
      expect(completion_percent).to eq result
    end
  end
end
