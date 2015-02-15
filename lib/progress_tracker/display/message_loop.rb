module ProgressTracker
  class Display
    class MessageLoop
      attr :queue, :main_thread, :renderer

      def initialize(queue, main_thread, renderer)
        @queue = queue
        @main_thread = main_thread
        @renderer = renderer
      end

      def perform
        loop do
          message = queue.pop
          case message[:type]
            when :update
              on_update(message[:task], message[:event], message[:details])
            when :timer
              on_timer
            when :input
              on_input message[:key]
          end
        end
      rescue => error
        main_thread.raise error
      end

      private

      def on_update(task, event, details)
        case event
          when :status
            renderer.task = task
            renderer.refresh
        end
      end

      def on_input(key)
        case key
          when ?\C-c
            main_thread.raise Interrupt
          when "\e[A"
            collapse
          when "\e[B"
            expand
          else
            puts key.inspect
        end
      end

      def on_timer
        @renderer.refresh
      end
    end
  end
end
