module ProgressMonitor
  class Display
    class MessageRenderer
      attr :message

      def initialize(message)
        @message = message
      end

      def render
        print clear_code, info_tag, message
      end

      private

      def clear_code
        "\e[2K\r"
      end

      def info_tag
        "\e[33;7m #{Time.now.strftime '%H:%M'} \e[0m "
      end
    end
  end
end
