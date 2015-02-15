module ProgressTracker
  class Display
    class Renderer
      attr_accessor :task

      def initialize(task)
        @task = task
      end

      def refresh
        left = task.name
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
    end
  end
end

