module ProgressMonitor
  class Display
    class MultiLineRenderer

      # Manages a collection of many line renderers
      class LineRendererCollection
        attr :line_renderers

        def initialize
          @line_renderers = []
        end

        # Updates collection of line renderers to accurately reflect the given tasks. Creates new line renderers if
        # needed, and nils out the task on any line renderers that are not currently needed
        def update_tasks(tasks)
          tasks.each_with_index do |task, i|
            if line_renderer = line_renderers[i]
              line_renderer.task = task
            else
              line_renderers[i] = LineRenderer.new(task)
            end
          end
          if tasks.count < line_renderers.count
            (tasks.count...line_renderers.count).each do |i|
              line_renderers[i].task = nil
            end
          end
        end

        def count
          line_renderers.count
        end

        # Checks if any line renderers are ready to be refreshed
        def any_need_refresh?
          line_renderers.any?(&:needs_refresh?)
        end

        # Refreshes all of the line renderers managed by this collection, first moving to the correct row for each
        # renderer. Specify force=true to refresh all items, regardless of whether or not they are stale
        def refresh(force=false)
          RowMover.new(count - 1) do |row_mover|
            line_renderers.each_with_index do |line_renderer, line|
              if force || line_renderer.needs_refresh?
                row_mover.row = line
                line_renderer.refresh
              end
            end
          end
        end

      end
    end
  end
end
