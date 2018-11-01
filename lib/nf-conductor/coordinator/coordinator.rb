require 'pry'
require 'concurrent'

module Conductor
  class Coordinator
    attr_accessor :workers, :polling_timers, :max_thread_count

    # Create a new Coordinator for a certain set of Workers.
    # A Worker is an implementation of the Worker Interface for a specific task.
    # Conductor::Coordinator.new([Conductor::Worker.new('matt-1'), Conductor::Worker.new('matt-2')])
    def initialize(workers, max_thread_count: 5)
      self.workers = workers
      self.polling_timers = []
      self.max_thread_count = max_thread_count
    end

    # Creates and executes a TimerTask for each Worker that the Coordinator has been instantiated with.
    # http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/TimerTask.html
    def run(execution_interval=15)
      self.workers.each do |worker|
        require 'byebug'; debugger
        $i = 0
        $num = 3

        while $i < $num  do
        # polling_timer = Concurrent::TimerTask.new(execution_interval: execution_interval) do
          puts("Conductor::Coordinator : Worker (#{worker.task_type}) polling...") if Conductor.config.verbose
          poll_for_task(worker)
          sleep 5
        end

        self.polling_timers << polling_timer
        polling_timer.execute
      end
    end

    # Shuts down all polling_timers for the Coordinator. Workers will no longer poll for new Tasks.
    def stop
      self.polling_timers.each do |polling_timer|
        polling_timer.shutdown
      end
      self.polling_timers = []
    end

    # Executed once every x seconds based on the parent polling_timer.
    # Batch polls the Conductor task queue for the given worker and task type,
    # and executes as many tasks concurrently as possible, using a CachedThreadPool
    # http://ruby-concurrency.github.io/concurrent-ruby/file.thread_pools.html
    def poll_for_task(worker)
      # TODO bulk poll for task, concurrently, up to size of queue
      tasks = [Conductor::Tasks.poll_task(worker.task_type)]
      tasks.each do |task|
        next if task[:status] != 200
        process_task(worker, task[:body])
      end
    rescue => e
      puts("Conductor::Coordinator : Failed to poll worker (#{worker.task_type}) with error #{e.message}")
    end

    # Acknowledges the Task in Conductor, then passes the Task to the Worker to execute.
    # Update the Task in Conductor with status and output data.
    def process_task(worker, task)
      puts("Conductor::Coordinator : Processing task #{task}") if Conductor.config.verbose

      task_identifiers = {
        taskId: task[:taskId],
        workflowInstanceId: task[:workflowInstanceId]
      }

      # Acknowledge the task, so other pollers will not be able to see the task in Conductor's queues
      Conductor::Tasks.acknowledge_task(task[:taskId])

      # Execute the task with the implementing application's worker
      result = worker.execute(task)
      task_body = result.merge!(task_identifiers)

      # Update Conductor about the result of the task
      update_task_with_retry(task_body, 0)
    rescue => e
      puts("Conductor::Coordinator : Failed to process task (#{task}) with error #{e.message} at location #{e.backtrace}")
      update_task_with_retry({ status: 'FAILED' }.merge(task_identifiers), 0)
    end

    def update_task_with_retry(task_body, count)
      # Put this in a retryable block instead
      begin
        return if count >= 3
        Conductor::Tasks.update_task(task_body)
      rescue
        update_task_with_retry(task_body, count+1)
      end
    end
  end
end
