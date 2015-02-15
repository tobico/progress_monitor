module ProgressTracker
  class Display
    class InputHandler
      attr :queue

      def initialize(queue)
        @queue = queue
        @status = :normal
      end

      def run
        loop { get_key }
      end

      def get_key
        key = STDIN.getch
        case @status
          when :normal
            if key == "\e"
              @status = :escape
            else
              send_key(key)
            end
          when :escape
            if key == "["
              @status = :special
            else
              send_key("\e#{key}")
              @status = :normal
            end
          when :special
            send_key("\e[#{key}")
            @status = :normal
        end
      rescue => e
        puts e.inspect
      end

      def send_key(key)
        @queue << { type: :input, key: key }
      end
    end
  end
end
