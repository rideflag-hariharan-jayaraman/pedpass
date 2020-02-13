module AuthorizationHelper
  def authorize_device(device)
    request.headers['Token'] = authorization_token(device)
  end

  def authorization_token(device)
    Base64.encode64 "#{device.user_id}:#{device.user_id}:#{device.api_key}"
  end
end
