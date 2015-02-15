require 'rubygems'
require 'bundler'

Bundler.load
require 'progress_tracker'

class Example

  class CreateUsers

    NAMES = %w(Joe Mary Steve Alexis Kate Stephanie Daniel Cassandra Keith Tyrion)

    attr :task

    def initialize(task)
      @task = task
    end

    def perform
      task.start
      task.add_and_run_subtasks NAMES, -> (name) { "Create user #{name}" } do |name, user_task|
        create_record, upload_photo, send_email = user_task.add_subtasks("Create user record", "Upload profile photo for #{name}", "Send welcome email")
        CreateRecord.new(create_record).perform
        UploadPhoto.new(name, upload_photo).perform
        SendEmail.new(send_email).perform
      end
      task.finish
    end

    class CreateRecord
      attr :task

      def initialize(task)
        @task = task
      end

      def perform
        task.start
        sleep 0.5
        task.finish
      end
    end

    class UploadPhoto
      attr :name, :task

      def initialize(name, task)
        @name = name
        @task = task
      end

      def perform
        task.start

        file = File.open(File.join(__dir__, 'sample.txt'))

        task.io = file

        until file.eof?
          file.getc
          sleep 0.05
        end
        file.close

        task.finish
      end
    end

    class SendEmail
      attr :task

      def initialize(task)
        @task = task
      end

      def perform
        task.start
        sleep 1
        task.finish
      end
    end
  end

  def perform
    task = ProgressTracker::Task.new("Initialize data")
    ProgressTracker::Display.new(task).display

    CreateUsers.new(task.add_subtask("Create users")).perform
  end

end

Example.new.perform
