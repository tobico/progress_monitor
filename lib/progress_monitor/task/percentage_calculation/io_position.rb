module ProgressMonitor
  class Task
    module PercentageCalculation
      class IoPosition
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          if task.io && task.io.size > 0
            (100.0 * task.io.pos / task.io.size).to_i
          end
        rescue
          nil
        end
      end
    end
  end
end
