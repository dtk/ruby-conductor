require 'faraday'

require 'nf-conductor/http/connection'
require 'nf-conductor/http/model'
require 'nf-conductor/http/metadata'
require 'nf-conductor/http/tasks'
require 'nf-conductor/http/workflow'

require 'nf-conductor/worker/worker'

require 'nf-conductor/coordinator/coordinator'

module Conductor
  SERVICE_URI_DEVELOPMENT = 'http://cpeworkflowdevint.dyntest.netflix.net:7001/'
  SERVICE_URI_TESTING     = 'http://cpeworkflowtestintg.dyntest.netflix.net:7001/'
  SERVICE_URI_PRODUCTION  = 'http://cpeworkflow.dynprod.netflix.net:7001/'

  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield(config) if block_given?
    end

    def initialize(service_env, verbose: false)
      configure if self.config.nil?
      self.config.service_env ||= service_env
      self.config.verbose ||= verbose

      # Ensure service_uri is set in configuration
      if self.config.service_env.nil? && self.config.service_uri.nil?
        raise "Service information is required"
      elsif self.config.service_uri
        # No action required
      elsif self.config.service_env
        self.config.service_uri = case self.config.service_env
                                  when 'development'
                                    SERVICE_URI_DEVELOPMENT
                                  when 'testing'
                                    SERVICE_URI_TESTING
                                  when 'production'
                                    SERVICE_URI_PRODUCTION
                                  end
      end
    end
  end

  class Configuration
    attr_accessor :service_env, :service_uri, :verbose
  end
end
