module Oauth
  class Client
    attr_reader :provider, :token, :params

    def initialize(provider, token, params = {})
      @provider = provider.to_sym
      @token = token
      @params = params
    end

    def fetch
      @data ||= OpenStruct.new auth_client.fetch
    rescue StandardError => e
      raise ConnectionError.new e.message
    end

    def auth_client
      @server ||= self.send(provider)
    end

    private
    def facebook
      Oauth::Facebook.new(token)
    end
  end
end
