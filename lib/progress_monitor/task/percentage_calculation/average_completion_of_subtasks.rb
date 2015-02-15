module ProgressMonitor
  class Task
    module PercentageCalculation
      class AverageCompletionOfSubtasks
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          if task.subtasks.any?
            average(task.subtasks.map(&:completion_percent).reject{|x| x == :unknown})
          end
        rescue
          nil
        end

        private

        def average(items)
          count = items.count
          if count > 0
            sum = items.reduce(:+)
            sum / count
          else
            0
          end
        end
      end
    end
  end
end
