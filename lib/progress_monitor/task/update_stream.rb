require 'observer'

module ProgressMonitor
  class Task
    class UpdateStream
      include Observable

      def notify(task, event, details)
        changed
        notify_observers task, event, details
      end
    end
  end
end
