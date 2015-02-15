module ProgressTracker
  class Display
    attr :task

    def initialize(task)
      @task = task
    end

    def display
      @current_task = task
      redisplay

      task.add_observer observer

      @main_thread = Thread.current
      @input_thread = Thread.new { input_handler.run }
      @timer_thread = Thread.new { timer_loop }
      @display_thread = Thread.new { message_loop }
    end

    private

    def queue
      @queue ||= Queue.new
    end

    def observer
      @observer ||= Observer.new(queue)
    end

    def input_handler
      @input_handler ||= InputHandler.new(queue)
    end

    def timer_loop
      loop do
        sleep 0.5
        queue << {type: :timer}
      end
    end

    def message_loop
      loop do
        message = queue.pop
        case message[:type]
          when :update
            update(message[:task], message[:event], message[:details])
          when :timer
            redisplay
          when :input
            handle_key message[:key]
        end
      end
    end

    def update(task, event, details)
      case event
        when :status
          update_status(task, details)
      end
    end

    def update_status(task, details)
      if details[:status] == :started
        @current_task = task
        redisplay
      end
    end

    def handle_key(key)
      case key
        when ?\C-c
          @main_thread.raise Interrupt
        when "\e[A"
          collapse
        when "\e[B"
          expand
        else
          puts key.inspect
      end
    end

    def redisplay
      left = @current_task.name
      progress_bar = ProgressBar.new(size: 20)
      progress_bar.completion_percent = task.completion_percent
      right = progress_bar.render
      spacing = " " * (columns - left.length - right.length)

      print clear_code, left, spacing, "\e[48;5;235m\e[32m", right, "\e[0m\r\e[#{left.length}C"
    rescue => e
      puts "\r\n", e.inspect, e.backtrace
      nil
    end

    def clear_code
      "\e[1K\r"
    end

    def columns
      STDIN.winsize[1]
    end

    class Observer
      attr :queue

      def initialize(queue)
        @queue = queue
      end

      def update(task, event, details)
        @queue << {type: :update, task: task, event: event, details: details}
      end
    end
  end
end
