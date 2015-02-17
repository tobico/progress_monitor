#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

Bundler.load
require 'progress_monitor'

class Example

  class CreateUsers

    NAMES = %w(Joe Mary Steve Alexis Kate)

    attr :task

    def initialize(task)
      @task = task
    end

    def perform
      task.start
      task.add_and_run_subtasks NAMES, -> (name) { "Create user #{name}" } do |name, user_task|
        user_task.start
        create_record_task, upload_photo_task, send_email_task = user_task.add_subtasks(
          "Create user record",
          "Upload profile photo for #{name}",
          "Send welcome email"
        )
        CreateRecord.new(name, create_record_task).perform
        UploadPhoto.new(name, upload_photo_task).perform
        SendEmail.new(send_email_task).perform
        user_task.finish
      end
      task.finish
    end

    class CreateRecord
      attr :name, :task

      def initialize(name, task)
        @name = name
        @task = task
      end

      def perform
        task.start
        sleep 0.5
        task.info "Created user #{name} with name length of #{name.length}"
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

        puts "Uploading file of size #{file.size}"

        task.file = file

        until file.eof?
          file.getc
          sleep 0.02
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
    task = ProgressMonitor::Task.new("Demonstrate Progress Monitor")
    ProgressMonitor::Display.new(task).display do
      create_users_task = task.add_subtask("Create users")
      shuffle_deck_chairs = task.add_subtask("Shuffle deck chairs")

      CreateUsers.new(create_users_task).perform
      subtasks = shuffle_deck_chairs.add_subtasks(*(1..80).to_a.map{|x| "Shuffle chair #{x}"})
      subtasks.each do |task|
        task.start
        sleep 0.5
        task.finish
      end
    end
  end

end

Example.new.perform
