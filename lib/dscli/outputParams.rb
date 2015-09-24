require 'interact'

module Dscli
  class OutputParams
    include Interactive

    FORMATS = ['json_new_line', 'json_meta', 'json_array']
    S3_ACL = ['private', 'public-read', 'public-read-write', 'authenticated-read', 'bucket-owner-read', 'bucket-owner-full-control']
    HTTP_AUTH_TYPE = ['none', 'basic']
    DELIVERY_FREQUENCY = [0, 10, 30, 60, 300]
    MAX_SIZE = ['100KB', '250KB', '500KB', '1MB', '2MB', '5MB', '10MB', '20MB']
    HTTP_METHOD = ['POST', 'PUT']
    BOOL = ['true', 'false']

    def acl
      ask 'ACL', choices: S3_ACL.each, indexed: true, default: S3_ACL.first
    end

    def api_hostname
      ask 'Splunk Storm REST API host'
    end

    def auth_access_key
      ask 'AWS access key'
    end

    def auth_access_token
      ask 'Splunk Storm REST access token'
    end

    def auth_password
      ask 'Authentication password'
    end

    def auth_secret_key
      ask 'AWS secret key'
    end

    def auth_username
      ask 'Authentication username'
    end

    def auth_type
      ask 'Auth type', choices: HTTP_AUTH_TYPE.each, indexed: true, default: HTTP_AUTH_TYPE.first
    end

    def bucket
      ask 'Bucket name'
    end

    def collection_name
      ask 'MongoDB Collection name'
    end

    def database
      ask 'Numeric ID of your existing Redis database'
    end

    def db_name
      ask 'Database name'
    end

    def delivery_frequency
      ask 'Delivery frequency (seconds)', choices: DELIVERY_FREQUENCY.each, indexed: true, default: DELIVERY_FREQUENCY.first
    end

    def directory
      ask 'Directory'
    end

    def file_prefix
      ask 'Optional filename prefix', default: 'DataSift'
    end

    def format
      ask 'Output format', choices: FORMATS.each, indexed: true
    end

    def host
      ask 'The host to connect to'
    end

    def list
      ask 'Name of a Redis list to stores interactions'
    end

    def max_size
      max_size = ask 'Max delivery size', choices: MAX_SIZE.each, indexed: true, default: MAX_SIZE.last
      human_size_to_number(max_size)
    end

    def method
      ask 'HTTP request type', choices: HTTP_METHOD.each, indexed: true, default: HTTP_METHOD.first
    end

    def port
      ask 'Port on the remote machine'
    end

    def project_id
      ask 'ID of your Splunk Storm REST project'
    end

    def region
      ask 'AWS region the destination table is set up in'
    end

    def server_level_auth_password
      ask 'Server-level authentication password'
    end

    def server_level_auth_username
      ask 'Server-level authentication username'
    end

    def source
      ask 'Label used to mark data delivered to Zoomdata'
    end

    def table
      ask 'Name of the table to use'
    end

    def type
      ask 'The type that you want to use for the index'
    end

    def url
      ask 'The URL to post data to'
    end

    def use_gzip
      ask 'Use GZip?', choices: BOOL.each, indexed: true, default: BOOL.last
    end

    def use_ssl
      ask 'Use SSL?', choices: BOOL.each, indexed: true, default: BOOL.last
    end

    def verify_ssl
      ask 'Verify SSL certificate?', choices: BOOL.each, indexed: true, default: BOOL.last
    end

    ###############

    #TODO properly add back in the namespacing. i.e. op_params.auth.passw

    private

    def human_size_to_number(size)
      value = size.scan(/[A-Z]+\d*|\d+/)
      bytes = value[0].to_i * 1024 if value[1] == 'KB'
      bytes = value[0].to_i * 1024 * 1024 if value[1] == 'MB'
      return bytes.to_s
    end

  end
end

