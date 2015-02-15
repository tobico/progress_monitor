module ProgressTracker
  class Display
    class TimerLoop
      attr :queue

      def initialize(queue)
        @queue = queue
      end

      def perform
        loop do
          sleep 0.1
          queue << {type: :timer}
        end
      end
    end
  end
end
