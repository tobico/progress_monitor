require 'progress_monitor/support/service'

module ProgressMonitor
  class Display
    class TimerLoop < Support::Service
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
