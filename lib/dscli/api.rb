require 'datasift'
require 'yajl'

module Dscli
  class API
    attr_reader :hash

    def initialize
      storage = Dscli::Storage.new
      config = storage.get_auth
      @config = {:username => config[:auth][:username], :api_key => config[:auth][:api_key], :enable_ssl => true}
      @datasift = DataSift::Client.new(@config)
    end

    #
    # Core API endpoints
    # [ Missing /validate /balance ]

    def compile(csdl)
      response = @datasift.compile csdl
      definition = response[:data]
      definition[:hash]
    end

    def usage(period)
      response = @datasift.usage period
      usage = response[:data]
    end

    def dpu(hash)
      response = @datasift.dpu hash
      dpu = response[:data]
    end

    def balance
      response = @datasift.balance
      return response[:data]
    end

    def stream(hash)
      on_delete  = lambda { |stream, m| puts m }
      on_error   = lambda { |stream, e| puts 'A serious error has occurred: ' + e.message.to_s }
      on_message = lambda { |message, stream, hash| puts Yajl::Encoder.encode(message) }
      on_connect = lambda { |stream| stream.subscribe(hash, on_message) }
      on_close   = lambda { |stream, message| puts "Closed #{stream}: #{message}" }

      on_datasift_message = lambda do |stream, message, hash|
        puts "DataSift Message #{hash} ==> #{message}"
      end

      conn = DataSift::new_stream(@config, on_delete, on_error, on_connect, on_close)
      conn.on_datasift_message = on_datasift_message
      conn.stream.read_thread.join

      rescue DataSiftError => dse
        puts "Error #{dse.message}"
        case dse
          when ConnectionError
          when AuthError
          when BadRequestError
            puts "Error #{dse.message}"
        end
    end

    #######################################################
    #     PUSH
    #######################################################

    def push_list(page)
      response = @datasift.push.get(page)
      response[:data]
    end

    def push_get(id)
      response = @datasift.push.get_by_subscription(id)
      return response
    end

    def push_stop(id)
      response = @datasift.push.stop(id)
      puts response
    end

    def push_delete(id)
      response = @datasift.push.delete(id)
      return response
    end

    def push_log(id)

      if id.nil?
        response = @datasift.push.log
      else
        response = @datasift.push.log_for(id)
      end

      return response[:data]

    end

    #######################################################
    #     HISTORICS
    #######################################################

    def historics_list(page)
      response = @datasift.historics.get(20,page)
      response[:data]
    end

    def historics_get(id)
      return @datasift.historics.get_by_id(id)
    end

    def historics_stop(id)
      return @datasift.historics.stop(id)
    end

    def historics_delete(id)
      return @datasift.historics.delete(id)
    end

    def historics_pause(id)
      return @datasift.historics.pause(id)
    end

    def historics_resume(id)
      return @datasift.historics.resume(id)
    end

    #######################################################
    #     MANAGED SOURCES
    #######################################################

    def source_list(page)
      response = @datasift.managed_source.get(nil,nil,page,20)
      response[:data]
    end

    def source_get(id)
      return @datasift.managed_source.get(id)
    end

    def source_start(id)
      return @datasift.managed_source.start(id)
    end

    def source_stop(id)
      return @datasift.managed_source.stop(id)
    end

    def source_delete(id)
      return @datasift.managed_source.delete(id)
    end

    def source_log(id)
      response = @datasift.managed_source.log(id,1,20)
      response[:data]
    end

  end

end
