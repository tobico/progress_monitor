module ProgressMonitor
  class Display
    # Moves the cursor between rows in the terminal history
    class RowMover
      attr :row, :initial_row

      # Specify a number for the row where the cursor currently is before we start moving it. This can be anything,
      # other operations will be relative to it.
      def initialize(row)
        @row = row
        @initial_row = row
        yield(self)
        reset
      end

      # Moves the cursor to the specified row, relative to the initial row
      def row=(value)
        if row < value
          STDOUT.print "\e[#{value - row}B"
        elsif row > value
          STDOUT.print "\e[#{row - value}A"
        end
        @row = value
      end

      # Returns the cursor to its initial position
      def reset
        self.row = initial_row
      end
    end
  end
end
