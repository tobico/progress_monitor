require "progress_monitor/task/percentage_calculation/status"
require "progress_monitor/task/percentage_calculation/file_position"
require "progress_monitor/task/percentage_calculation/average_completion_of_subtasks"

module ProgressMonitor
  class Task
    class PercentageCalculation
      PERCENTAGE_CALCULATORS = [
        Status,
        FilePosition,
        AverageCompletionOfSubtasks,
      ]

      attr :task

      def initialize(task)
        @task = task
      end

      def perform
        PERCENTAGE_CALCULATORS.each do |calculator|
          result = calculator.new(task).perform
          return result if result
        end
        :unknown
      rescue => e
        puts e.inspect
        :unknown
      end
    end
  end
end
