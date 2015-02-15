require "progress_monitor/display/task_observer"
require "progress_monitor/display/input_loop"
require "progress_monitor/display/message_loop"
require "progress_monitor/display/timer_loop"

require "progress_monitor/display/multi_line_renderer"
require "progress_monitor/display/line_renderer"
require "progress_monitor/display/progress_bar"
require "progress_monitor/display/row_mover"

module ProgressMonitor
  class Display
    attr :task, :queue

    def initialize(task)
      @task = task
      @queue = Queue.new
    end

    def display
      @current_task = task

      @renderer = MultiLineRenderer.new(task)
      @renderer.refresh

      task.add_observer TaskObserver.new(queue)

      @main_thread = Thread.current
      Thread.new { InputLoop.new(queue).perform }
      Thread.new { TimerLoop.new(queue).perform }
      Thread.new { MessageLoop.new(queue, @main_thread, @renderer).perform }
    end
  end
end
