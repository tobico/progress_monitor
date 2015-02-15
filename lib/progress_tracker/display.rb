require "progress_tracker/display/task_observer"
require "progress_tracker/display/input_loop"
require "progress_tracker/display/message_loop"
require "progress_tracker/display/timer_loop"

require "progress_tracker/display/renderer"
require "progress_tracker/display/progress_bar"

module ProgressTracker
  class Display
    attr :task, :queue

    def initialize(task)
      @task = task
      @queue = Queue.new
    end

    def display
      @current_task = task

      @renderer = Renderer.new(task)
      @renderer.refresh

      task.add_observer TaskObserver.new(queue)

      @main_thread = Thread.current
      Thread.new { InputLoop.new(queue).perform }
      Thread.new { TimerLoop.new(queue).perform }
      Thread.new { MessageLoop.new(queue, @main_thread, @renderer).perform }
    end
  end
end
