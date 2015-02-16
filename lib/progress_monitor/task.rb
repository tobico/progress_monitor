require "progress_monitor/task/update_stream"
require "progress_monitor/task/percentage_calculation"

module ProgressMonitor
  class Task
    attr :name, :update_stream, :subtasks, :status, :started_at, :finished_at
    attr_accessor :file

    def initialize(name, update_stream=nil)
      @name = name
      @update_stream = update_stream || UpdateStream.new
      @subtasks = []
      @status = :new
    end

    def add_subtask(name)
      Task.new(name, update_stream).tap do |task|
        @subtasks << task
      end
    end

    def add_subtasks(*names)
      names.map &method(:add_subtask)
    end

    def add_and_run_subtasks(items, name_fn, &run_fn)
      items.map do |item|
        [item, add_subtask(name_fn.call(item))]
      end.map do |args|
        run_fn.call(*args)
      end
    end

    def start
      return unless status == :new

      update_stream.notify(self, :status_change, from: @status, to: :started)
      @status = :started
      @started_at = Time.now
    end

    def finish
      return unless status == :started

      update_stream.notify(self, :status_change, from: @status, to: :finished)
      @status = :finished
      @finished_at = Time.now
    end

    def info(message)
      update_stream.notify(self, :info, message: message)
    end

    def completion_percent
      PercentageCalculation.new(self).perform
    end
  end
end
