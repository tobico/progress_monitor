module ProgressMonitor
  class Display
    class ProgressBar
      attr_accessor :size, :completion_percent

      def initialize(size: 20, completion_percent: 0)
        @size = size
        @completion_percent = completion_percent
      end

      BAR_PROGRESS = "█"
      BAR_SPACE = " "
      BAR_PARTIAL_PROGRESS = [BAR_SPACE, '▏', '▎', '▍', '▌', '▋', '▊', '▉']

      def render
        if completion_percent == :unknown
          '╍' * size
        else
          completion_float = completion_percent.to_f / 100 * size
          completion_size = completion_float.floor
          remainder = (completion_float % 1 * 8).floor
          if completion_size < size
            BAR_PROGRESS * completion_size + BAR_PARTIAL_PROGRESS[remainder] + BAR_SPACE * (size - completion_size - 1)
          else
            BAR_PROGRESS * size
          end
        end
      rescue => e
        puts e
        ""
      end
    end
  end
end
