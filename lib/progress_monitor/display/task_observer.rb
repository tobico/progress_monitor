module ProgressMonitor
  class Display
    class TaskObserver
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
