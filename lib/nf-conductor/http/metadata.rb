module Conductor
  class Metadata < Model
    def initialize(response)
      super(response)
    end

    class << self
      # GET /metadata/taskdefs
      # Gets all task definition
      def get_all_tasks
        response = Connection.new.get("/metadata/taskdefs")
        Metadata.build(response)
      end

      # GET /metadata/taskdefs/{taskType}
      # Gets the task definition
      def get_task(task_type)
        response = Connection.new.get("/metadata/taskdefs/#{task_type}")
        Metadata.build(response)
      end

      # POST /metadata/taskdefs
      # Create new task definition(s)
      # 204 success
      def create_tasks(task_list)
        response = Connection.new.post(
          "/metadata/taskdefs",
          { body: (task_list.is_a?(Array) ? task_list : [task_list]).to_json }
        )
        Metadata.build(response)
      end

      # PUT /metadata/taskdefs
      # Update an existing task
      def update_task(task_definition)
        response = Connection.new.put(
          "/metadata/taskdefs",
          { body: task_definition.to_json }
        )
        Metadata.build(response)
      end

      # DELETE /metadata/taskdefs/{taskType}
      # Remove a task definition
      def delete_task(task_type)
        response = Connection.new.delete("/metadata/taskdefs/#{task_type}")
        Metadata.build(response)
      end

      # GET /metadata/workflow
      # Retrieves all workflow definition along with blueprint
      def get_all_workflows
        response = Connection.new.get("/metadata/workflow")
        Metadata.build(response)
      end

      # GET /metadata/workflow/{name}?version=
      # Retrieves workflow definition along with blueprint
      def get_workflow(workflow_name, version: nil)
        query_string = "/metadata/workflow/#{workflow_name}?"
        query_string += "version=#{version}" if version

        response = Connection.new.get(query_string)
        Metadata.build(response)
      end

      # POST /metadata/workflow
      # Create a new workflow definition
      def create_workflow(workflow)
        response = Connection.new.post(
          "/metadata/workflow",
          { body: workflow.to_json }
        )
        Metadata.build(response)
      end

      # PUT /metadata/workflow
      # Create or update workflow definition
      def create_or_update_workflows(workflow_list)
        response = Connection.new.put(
          "/metadata/taskdefs",
          { body: (workflow_list.is_a?(Array) ? workflow_list : [workflow_list]).to_json }
        )
        Metadata.build(response)
      end
    end
  end
end
