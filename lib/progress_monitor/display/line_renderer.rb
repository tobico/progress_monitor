require 'io/console'
require 'progress_monitor/display/progress_bar'

module ProgressMonitor
  class Display
    # Renders a single line on the terminal showing the name and progress of a task
    class LineRenderer
      attr :task

      def initialize(task)
        @current_state = :force_refresh
        @task          = task
      end

      def task=(value)
        old_value      = task
        @task          = value
        @current_state = :force_refresh if value != old_value
      end

      def needs_refresh?
        @current_state != task_state
      end

      def refresh
        render task_state
      end

      private

      def task_state
        if task
          {
            name:               task.name,
            completion_percent: task.completion_percent,
          }
        else
          :empty
        end
      end

      def render(state)
        if task
          left    = state[:name]
          right   = ProgressBar.perform(size: 20, completion_percent: state[:completion_percent])
          spacing = " " * (columns - left.length - right.length)

          STDOUT.print clear_code, left, spacing, "\e[48;5;235m\e[32m", right, "\e[0m\r\e[#{left.length}C"
        else
          STDOUT.print clear_code
        end
      rescue => e
        STDOUT.puts clear_code, e.inspect
        nil
      end

      def clear_code
        "\e[2K\r"
      end

      def columns
        STDIN.winsize[1]
      end
    end
  end
end

