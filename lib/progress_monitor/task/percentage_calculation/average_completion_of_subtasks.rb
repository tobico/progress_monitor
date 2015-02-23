require 'progress_monitor/support/service'

module ProgressMonitor
  class Task
    class PercentageCalculation < Support::Service
      class AverageCompletionOfSubtasks < Support::Service
        attr :task

        def initialize(task)
          @task = task
        end

        def perform
          if task.subtasks.any?
            average(task.subtasks.map(&:completion_percent).reject{|x| x == :unknown})
          end
        rescue
          :unknown
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
