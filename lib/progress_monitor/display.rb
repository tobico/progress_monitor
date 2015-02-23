require 'progress_monitor/display/task_observer'
require 'progress_monitor/display/input_loop'
require 'progress_monitor/display/message_loop'
require 'progress_monitor/display/timer_loop'
require 'progress_monitor/display/io_loop'
require 'progress_monitor/display/multi_line_renderer'

module ProgressMonitor
  class Display
    attr :task, :queue

    def initialize(task)
      @task  = task
      @queue = Queue.new
    end

    def show
      renderer.refresh

      task.update_stream.add_observer TaskObserver.new(queue)

      main_thread = Thread.current
      Thread.new { InputLoop.perform(queue) }
      Thread.new { TimerLoop.perform(queue) }
      Thread.new { MessageLoop.perform(queue, main_thread, renderer) }

      piped_stdout, self.stdout = IO.pipe
      Thread.new { IoLoop.perform(queue, piped_stdout).perform }

      yield

      sleep 0.2 until queue.empty?
      self.stdout = STDOUT
    end

    private

    def renderer
      @renderer ||= MultiLineRenderer.new(task)
    end

    def stdout=(value)
      $stdout = value
    end
  end
end
