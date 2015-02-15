module ProgressTracker
  class Display
    class Renderer
      attr_accessor :task

      def initialize(task)
        @task = task
        @current_state = nil
      end

      def refresh
        new_state = task_state

        if @current_state != new_state
          render task_state
          @current_state = new_state
        end

      rescue => e
        puts "\r\n", e.inspect, e.backtrace
        nil
      end

      private

      def task_state
        {
          name:               task.name,
          completion_percent: task.completion_percent,
        }
      end

      def render(state)
        left                            = state[:name]
        progress_bar                    = ProgressBar.new(size: 20)
        progress_bar.completion_percent = state[:completion_percent]
        right                           = progress_bar.render
        spacing                         = " " * (columns - left.length - right.length)

        print clear_code, left, spacing, "\e[48;5;235m\e[32m", right, "\e[0m\r\e[#{left.length}C"
      end

      def clear_code
        "\e[1K\r"
      end

      def columns
        STDIN.winsize[1]
      end
    end
  end
end

