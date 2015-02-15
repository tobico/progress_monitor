module ProgressTracker
  class Task
    module PercentageCalculation
      class AverageCompletionOfSubtasks
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          if task.subtasks.any?
            Utils.average task.subtasks.map(&:completion_percent)
          end
        end
      end
    end
  end
end
