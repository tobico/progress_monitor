module ProgressMonitor
  module Support
    class Service
      def self.perform(*args)
        new(*args).perform
      end
    end
  end
end
