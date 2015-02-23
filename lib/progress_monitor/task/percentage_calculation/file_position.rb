require 'progress_monitor/support/service'

module ProgressMonitor
  class Task
    class PercentageCalculation < Support::Service
      class FilePosition < Support::Service
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          if task.file && task.file.size > 0
            (100.0 * task.file.pos / task.file.size).to_i
          end
        rescue
          :unknown
        end
      end
    end
  end
end
