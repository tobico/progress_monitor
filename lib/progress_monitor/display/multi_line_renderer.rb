require 'progress_monitor/display/row_mover'
require 'progress_monitor/display/message_renderer'
require 'progress_monitor/display/multi_line_renderer/line_renderer_collection'

module ProgressMonitor
  class Display
    # Renders multi-line display showing the full task hierarchy from the root class down to the current task
    class MultiLineRenderer
      attr :root_task

      def initialize(root_task)
        @root_task = root_task
        @current_visible_tasks = []
        @consumed_lines = 1
        @line_renderer_collection = LineRendererCollection.new
      end

      def refresh
        update_visible_tasks if visible_tasks_need_update?
        render if @line_renderer_collection.any_need_refresh?
      rescue => e
        puts e.inspect, e.backtrace
      end

      def info(message)
        STDOUT.print "\n"
        RowMover.new(@line_renderer_collection.count - 1) do |row_mover|
          row_mover.row = -1
          MessageRenderer.perform(message)
        end
        @line_renderer_collection.refresh(true)
      end

      private

      def update_visible_tasks
        @current_visible_tasks = determine_visible_tasks
        @line_renderer_collection.update_tasks @current_visible_tasks
      end

      def visible_tasks_need_update?
        determine_visible_tasks != @current_visible_tasks
      end

      # Recursive function to find the list of tasks between the root task and the current task
      def determine_visible_tasks
        [root_task] + determine_visible_subtasks(root_task)
      end

      def determine_visible_subtasks(task)
        if subtask = task.subtasks.find{|t| t.status != :finished}
          [subtask] + determine_visible_subtasks(subtask)
        else
          []
        end
      end

      def render
        increase_consumed_lines_to(@line_renderer_collection.count)
        @line_renderer_collection.refresh
      end

      # Prints out empty lines to increase the amount of space we have in the terminal buffer to work with
      def increase_consumed_lines_to(value)
        while @consumed_lines < value
          STDOUT.print "\n"
          @consumed_lines += 1
        end
      end
    end
  end
end
