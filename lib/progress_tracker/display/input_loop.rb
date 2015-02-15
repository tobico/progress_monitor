module ProgressTracker
  class Display
    class InputLoop
      attr :queue

      def initialize(queue)
        @queue = queue
        @status = :normal
      end

      def perform
        loop { get_key }
      end

      private

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
