module ProgressMonitor
  class Display
    class Renderer
      attr :root_task

      def initialize(root_task)
        @root_task = root_task
        @current_visible_tasks = []
        @line_renderers = []
        @consumed_lines = 1
      end

      def refresh
        if line_renderers_need_update?
          @current_visible_tasks = determine_visible_tasks
          update_line_renderers
        end
        render if line_renderers_need_refresh?
      rescue => e
        puts e.inspect, e.backtrace
      end

      private

      def line_renderers_need_update?
        determine_visible_tasks != current_visible_tasks
      end

      def line_renderers_need_refresh?
        line_renderers.any?(&:needs_refresh?)
      end

      attr :current_visible_tasks, :line_renderers

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

      def update_line_renderers
        current_visible_tasks.each_with_index do |task, i|
          if line_renderer = line_renderers[i]
            line_renderer.task = task
          else
            line_renderers[i] = LineRenderer.new(task)
          end
        end
      end

      def render
        while @consumed_lines < line_renderers.count
          print "\n"
          @consumed_lines += 1
        end

        current_line = line_renderers.count - 1

        line_renderers.each_with_index do |line_renderer, line|
          if line_renderer.needs_refresh?
            move_lines(current_line, line)
            current_line = line
            line_renderer.refresh
          end
        end

        move_lines(current_line, line_renderers.count - 1)
      end

      def move_lines(current_line, destination_line)
        if current_line < destination_line
          print "\e[#{destination_line - current_line}B"
        elsif current_line > destination_line
          print "\e[#{current_line - destination_line}A"
        end
      end
    end
  end
end
