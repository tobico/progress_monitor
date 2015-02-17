module ProgressMonitor
  class Display
    class IoLoop
      attr :queue, :io

      def initialize(queue, io)
        @queue = queue
        @io = io
      end

      def perform
        loop do
          line = io.gets
          queue << {type: :stdout, line: line}
        end
      end
    end
  end
end
