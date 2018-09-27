module Conductor
  class Worker
    attr_accessor :task_type

    def method_not_implemented
      raise "Conductor::Worker: Interface method must be implemented by worker subclass"
    end

    def initialize(task_type)
      self.task_type = task_type
    end

    def execute(task)
      method_not_implemented
    end
  end
end
