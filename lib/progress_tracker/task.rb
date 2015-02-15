require "progress_tracker/task/percentage_calculation/status"
require "progress_tracker/task/percentage_calculation/io_position"
require "progress_tracker/task/percentage_calculation/average_completion_of_subtasks"

module ProgressTracker
  class Task
    include Observable

    attr :name, :parent, :subtasks, :status, :started_at, :finished_at
    attr_accessor :io

    PERCENTAGE_CALCULATORS = [
      PercentageCalculation::Status,
      PercentageCalculation::IoPosition,
      PercentageCalculation::AverageCompletionOfSubtasks,
    ]

    def initialize(name, parent=nil)
      @name = name
      @parent = parent
      @subtasks = []
      @status = :new
    end

    def start
      return unless status == :new

      parent.start if parent
      @status = :started
      @started_at = Time.now
      notify_status
    end

    def finish
      return unless status == :started

      parent.finish_if_subtasks_finished
      @status = :finished
      @finished_at = Time.now
      notify_status
    end

    def duration
      finished_at - started_at
    end

    def add_subtask(name)
      Task.new(name, self).tap do |task|
        @subtasks << task
      end
    end

    def add_subtasks(*names)
      names.map &method(:add_subtask)
    end

    def add_and_run_subtasks(items, name_fn, &run_fn)
      items.map do |item|
        [item, add_subtask(name_fn.call(item))]
      end.each do |args|
        run_fn.call(*args)
      end
    end

    def completion_percent
      PERCENTAGE_CALCULATORS.each do |calculator|
        result = calculator.new(self).perform
        return result if result
      end
      :unknown
    rescue => e
      puts e.inspect
      :unknown
    end

    protected

    def notify(task, event, details)
      parent.notify task, event, details if parent
      changed
      notify_observers task, event, details
    end

    def finish_if_subtasks_finished
      finish if subtasks.all?{|st| st.status == :finished}
    end

    private

    def notify_status
      notify self, :status, {status: status}
    end
  end
end
