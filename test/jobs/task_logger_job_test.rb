# frozen_string_literal: true

require "test_helper"
require "sidekiq/testing"

class TaskLoggerJobTest < ActiveJob::TestCase
  # Since Rails 7.2 ActiveJob::TestCase keeps the app's adapter unless told otherwise.
  def queue_adapter_for_test
    ActiveJob::QueueAdapters::TestAdapter.new
  end

  def setup
    @task = create(:task)
  end

  test "logger runs once after creating a new task" do
    assert_enqueued_with(job: TaskLoggerJob, args: [@task])
    perform_enqueued_jobs
    assert_performed_jobs 1
  end

  test "log count increments on running task logger" do
    Sidekiq::Testing.inline!
    assert_difference "Log.count", 1 do
      TaskLoggerJob.new.perform(@task)
    end
  end
end
