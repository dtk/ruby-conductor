module Conductor
  class Tasks < Model
    def initialize(response)
      super(response)
    end

    class << self
      # GET /tasks/poll/batch/{tasktype}
      # batch Poll for a task of a certain type
      def batch_poll_for_tasks(task_type, worker_id: nil, domain: nil, count: nil, timeout: nil)
        query_string = "/api/tasks/poll/batch/#{task_type}?"
        query_string += "workerid=#{worker_id}" if worker_id
        query_string += "&domain=#{domain}" if domain
        query_string += "&count=#{count}" if count
        query_string += "&timeout=#{timeout}" if timeout

        response = Connection.new.get(query_string)
        Tasks.build(response)
      end

      # GET /tasks/in_progress/{tasktype}
      # Get in progress tasks. The results are paginated.
      def get_in_progress_tasks(task_type, start_key: nil, count: nil)
        query_string = "/api/tasks/in_progress/#{task_type}?"
        query_string += "startKey=#{start_key}" if start_key
        query_string += "&count=#{count}" if count

        response = Connection.new.get(query_string)
        Tasks.build(response)
      end

      # GET /tasks/in_progress/{workflowId}/{taskRefName}
      # Get in progress task for a given workflow id.
      def get_in_progress_task_in_workflow(workflow_id, task_name)
        response = Connection.new.get("/api/tasks/in_progress/#{workflow_id}/#{task_name}")
        Tasks.build(response)
      end

      # POST /tasks
      # Update a task
      def update_task(task_body)
        response = Connection.new.post(
          "/api/tasks",
          { body: task_body.to_json }
        )
        Tasks.build(response)
      end

      # POST /tasks/{taskId}/ack
      # Ack Task is recieved
      def acknowledge_task(task_id, worker_id: nil)
        query_string = "/api/tasks/#{task_id}/ack?"
        query_string += "workerid=#{worker_id}" if worker_id

        response = Connection.new.post(query_string)
        Tasks.build(response)
      end

      # GET /tasks/{taskId}/log
      # Get Task Execution Logs
      def get_task_logs(task_id)
        response = Connection.new.get("/api/tasks/#{task_id}/log")
        Tasks.build(response)
      end

      # POST /tasks/{taskId}/log
      # Log Task Execution Details
      def add_task_log(task_id, task_log)
        response = Connection.new.post(
          "/api/tasks/#{task_id}/log",
          { body: task_log.to_json }
        )
        Tasks.build(response)
      end

      # DELETE /tasks/queue/{taskType}/{taskId}
      # Remove Task from a Task type queue
      def remove_task(task_type, task_id)
        response = Connection.new.delete("/api/tasks/queue/#{task_type}/#{task_id}")
        Tasks.build(response)
      end

      # GET /tasks/queue/all/verbose
      # Get the details about each queue
      def get_all_tasks_verbose
        response = Connection.new.get("/api/tasks/queue/all/verbose")
        Tasks.build(response)
      end

      # GET /tasks/queue/polldata
      # Get the last poll data for a given task type
      def get_poll_data(task_type)
        response = Connection.new.get("/api/tasks/queue/polldata?taskType=#{task_type}")
        Tasks.build(response)
      end

      # GET /tasks/queue/polldata/all
      # Get the last poll data for a given task type
      def get_all_poll_data
        response = Connection.new.get("/api/tasks/queue/polldata/all")
        Tasks.build(response)
      end

      # POST /tasks/queue/requeue/{taskType}
      # Requeue pending tasks
      def requeue_tasks(task_type)
        response = Connection.new.post("/api/tasks/queue/requeue/#{task_type}")
        Tasks.build(response)
      end

      # POST /tasks/queue/requeue
      # Requeue pending tasks for all the running workflows
      def requeue_all_tasks
        response = Connection.new.post("/api/tasks/queue/requeue")
        Tasks.build(response)
      end

      # GET /tasks/queue/sizes
      # Get Task type queue sizes
      def get_queue_sizes(task_types)
        task_types_query = task_types.is_a?(Array) ? task_types.to_query('taskType') : "taskType=#{taskType}"

        response = Connection.new.get("/api/tasks/queue/sizes?#{task_types_query}")
        Tasks.build(response)
      end

      # GET /tasks/poll/{tasktype}
      # Poll for a task of a certain type
      def poll_task(task_type, worker_id: nil, domain: nil)
        query_string = "/api/tasks/poll/#{task_type}?"
        query_string += "workerid=#{worker_id}" if worker_id
        query_string += "&domain=#{domain}" if domain

        response = Connection.new.get(query_string)
        Tasks.build(response)
      end

      # GET /tasks/search
      # Search for tasks based in payload and other parameters
      def search_task(start: nil, size: nil, sort: nil, free_text: nil, query: nil)
        query_string = "/api/tasks/search?"
        query_string += "start=#{start}" if start
        query_string += "&size=#{size}" if size
        query_string += "&sort=#{sort}" if sort
        query_string += "&freeText=#{free_text}" if free_text
        query_string += "&query=#{query}" if query

        response = Connection.new.get(query_string)
        Tasks.build(response)
      end

      # GET /tasks/queue/all
      # Get the details about each queue
      def get_all_tasks
        response = Connection.new.get("/api/tasks/queue/all")
        Tasks.build(response)
      end

      # GET /tasks/{taskId}
      # Get task by Id
      def get_task(task_id)
        response = Connection.new.get("/api/tasks/#{task_id}")
        Tasks.build(response)
      end
    end
  end
end
