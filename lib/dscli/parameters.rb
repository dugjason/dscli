require 'interact'

module Dscli
  class Parameters
    include Interactive

    def user_config(options)
      config = options.dup
      username = ask 'DataSift Username'
      api_key  = ask 'DataSift API Key'

      config = { auth: { username: username, api_key: api_key } }
    end
  end
end
