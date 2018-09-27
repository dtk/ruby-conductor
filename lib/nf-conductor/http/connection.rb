require 'faraday_middleware'

# blahb alh

module Conductor
  class Connection
    attr_reader :connection, :args
  require 'logger'
  @@logger = Logger.new(STDOUT)
    def initialize(args = {})
      @connection ||= Faraday.new(url: Conductor.config.service_uri) do |c|
        c.request :json
        c.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
        c.adapter Faraday.default_adapter
      end

      args.each do |k,v|
        @connection.headers[k] = v
      end
    end

    def get(url, args={})
      @@logger.info("Conductor::Connection : GET #{url} with args #{args}") if Conductor.config.verbose
      connection.get do |req|
        req.url url
        req.headers['Content-Type'] = ( args[:headers] && args[:headers]['Content-Type'] || 'application/json' )
        req.body = args[:body] if args[:body]
      end
    rescue Faraday::ParsingError
      Struct.new(:status, :body).new(500, 'Conductor::Connection : Faraday failed to properly parse response.')
    end

    def post(url, args={})
      logger.info("Conductor::Connection : POST #{url} with args #{args}") if Conductor.config.verbose
      connection.post do |req|
        req.url url
        req.headers['Content-Type'] = ( args[:headers] && args[:headers]['Content-Type'] || 'application/json' )
        req.body = args[:body] if args[:body]
      end
    rescue Faraday::ParsingError
      Struct.new(:status, :body).new(500, 'Conductor::Connection : Faraday failed to properly parse response.')
    end

    def put(url, args={})
      logger.info("Conductor::Connection : PUT #{url} with args #{args}") if Conductor.config.verbose
      connection.put do |req|
        req.url url
        req.headers['Content-Type'] = ( args[:headers] && args[:headers]['Content-Type'] || 'application/json' )
        req.body = args[:body] if args[:body]
      end
    rescue Faraday::ParsingError
      Struct.new(:status, :body).new(500, 'Conductor::Connection : Faraday failed to properly parse response.')
    end

    def delete(url, args={})
      logger.info("Conductor::Connection : DELETE #{url} with args #{args}") if Conductor.config.verbose
      connection.delete do |req|
        req.url url
        req.headers['Content-Type'] = ( args[:headers] && args[:headers]['Content-Type'] || 'application/json' )
        req.body = args[:body] if args[:body]
      end
    rescue Faraday::ParsingError
      Struct.new(:status, :body).new(500, 'Conductor::Connection : Faraday failed to properly parse response.')
    end
  end
end

