module AuthorizationHelper
  def authorize_device(device)
    request.headers['Authorization'] = authorization_token(device)
  end

  def authorization_token(device)
    JsonWebToken.encode(
      user_id: device.user.id, device_token: device.api_key,
      exp: (Time.zone.now + 1.month).to_i
    )
  end
end
