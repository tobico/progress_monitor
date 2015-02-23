require 'progress_monitor/support/service'

module ProgressMonitor
  class Task
    class PercentageCalculation < Support::Service
      class Status < Support::Service
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          case task.status
            when :new
              0
            when :finished
              100
          end
        rescue
          nil
        end
      end
    end
  end
end
