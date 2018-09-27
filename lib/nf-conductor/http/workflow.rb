module Conductor
  class Workflow < Model
    def initialize(response)
      super(response)
    end

    class << self
      # POST /workflow/{name}
      # Start a new workflow. Returns the ID of the workflow instance that can be later used for tracking
      def start_workflow(name, version: nil, correlation_id: nil, body: {})
        query_string = "/workflow/#{name}?"
        query_string += "version=#{version}" if version
        query_string += "&correlationId=#{correlation_id}" if correlation_id

        response = Connection.new.post(
          query_string,
          { body: body.to_json }
        )
        Workflow.build(response)
      end

      # POST /workflow
      # Start a new workflow with StartWorkflowRequest, which allows task to be executed in a domain
      def start_workflow_with_domains(workflow)
        response = Connection.new.post(
          "/workflow",
          { body: workflow.to_json }
        )
        Workflow.build(response)
      end

      # GET /workflow/{name}/correlated/{correlationId}
      # Lists workflows for the given correlation id
      def get_correlated_workflows(workflow_name, correlation_id, include_closed: false, include_tasks: false)
        response = Connection.new.get(
          "/workflow/#{workflow_name}/correlated/#{correlation_id}?includeClosed=#{include_closed}&includeTasks=#{include_tasks}"
        )
        Workflow.build(response)
      end

      # DELETE /workflow/{workflowId}
      # Terminate workflow execution
      def terminate_workflow(workflow_id, reason: nil)
        query_string = "/workflow/#{workflow_id}?"
        query_string += "reason=#{reason}" if reason

        response = Connection.new.delete(query_string)
        Workflow.build(response)
      end

      # GET /workflow/{workflowId}
      # Gets the workflow by workflow id
      def get_workflow(workflow_id, include_tasks: true)
        response = Connection.new.get(
          "/workflow/#{workflow_id}?includeTasks=#{include_tasks}"
        )
        Workflow.build(response)
      end

      # GET /workflow/running/{name}
      # Retrieve all the running workflows
      def get_running_workflow(workflow_name, version: nil, start_time: nil, end_time: nil)
        query_string = "/workflow/running/#{workflow_name}?"
        query_string += "version=#{version}" if version
        query_string += "&startTime=#{start_time}" if start_time
        query_string += "&endTime=#{end_time}" if end_time

        response = Connection.new.get(query_string)
        Workflow.build(response)
      end

      # PUT /workflow/decide/{workflowId}
      # Starts the decision task for a workflow
      def decide_workflow(workflow_id)
        response = Connection.new.put("/workflow/decide/#{workflow_id}")
        Workflow.build(response)
      end

      # PUT /workflow/{workflowId}/pause
      # Pauses the workflow
      def pause_workflow(workflow_id)
        response = Connection.new.put("/workflow/#{workflow_id}/pause")
        Workflow.build(response)
      end

      # PUT /workflow/{workflowId}/resume
      # Resumes the workflow
      def resume_workflow(workflow_id)
        response = Connection.new.put("/workflow/#{workflow_id}/resume")
        Workflow.build(response)
      end

      # PUT /workflow/{workflowId}/skiptask/{taskReferenceName}
      # Skips a given task from a current running workflow
      def skip_task_for_workflow(workflow_id, task_name, task_body: {})
        response = Connection.new.put(
          "/workflow/#{workflow_id}/skiptask/#{task_name}",
          { body: task_body.to_json }
        )
        Workflow.build(response)
      end

      # POST /workflow/{workflowId}/rerun
      # Reruns the workflow from a specific task
      def rerun_workflow(workflow_id, rerun_body: {})
        response = Connection.new.post(
          "/workflow/#{workflow_id}/rerun",
          { body: rerun_body.to_json }
        )
        Workflow.build(response)
      end

      # POST /workflow/{workflowId}/restart
      # Restarts a completed workflow
      def restart_workflow(workflow_id)
        response = Connection.new.post("/workflow/#{workflow_id}/restart")
        Workflow.build(response)
      end

      # POST /workflow/{workflowId}/retry
      # Retries the last failed task
      def retry_workflow(workflow_id)
        response = Connection.new.post("/workflow/#{workflow_id}/retry")
        Workflow.build(response)
      end

      # DELETE /workflow/{workflowId}/remove
      # Removes the workflow from the system
      def delete_workflow(workflow_id)
        response = Connection.new.delete("/workflow/#{workflow_id}/remove")
        Workflow.build(response)
      end

      # POST /workflow/{workflowId}/resetcallbacks
      # Resets callback times of all in_progress tasks to 0
      def reset_callbacks_for_workflow(workflow_id)
        response = Connection.new.post("/workflow/#{workflow_id}/resetcallbacks")
        Workflow.build(response)
      end

      # GET /workflow/search
      def search_workflows(start: nil, size: nil, sort: nil, free_text: nil, query: nil)
        query_string = "/workflow/search?"
        query_string += "start=#{start}" if start
        query_string += "&size=#{size}" if size
        query_string += "&sort=#{sort}" if sort
        query_string += "&freeText=#{free_text}" if free_text
        query_string += "&query=#{query}" if query

        response = Connection.new.get(query_string)
        Workflow.build(response)
      end
    end
  end
end
