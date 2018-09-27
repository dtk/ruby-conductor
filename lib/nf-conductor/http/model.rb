module Conductor
  class Model
    attr_reader :response
    attr_accessor :status

    def initialize(response)
      @response = response
    end

    def self.build(response)
      {
        status: response.status,
        body: response.body
      }
    end
  end
end
