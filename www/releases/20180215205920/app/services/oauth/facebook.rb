module Oauth
  class Facebook
    attr_reader :token

    def initialize(token)
      @token = token
    end


    #TODO: Handle client token failing
    def fetch
      data = client.get_object('me?fields=email,gender,age_range')
      # NOTE: Since only an age range is given, let minimum be age
      data['age'] = data['age_range']['min']
      data['gender'] = data['gender'].match(/male|female/) ? data['gender'][0] : 'o'

      data.except 'age_range', 'id'
    end

    private
    def client
      @client ||= Koala::Facebook::API.new(token)
    end
  end
end
