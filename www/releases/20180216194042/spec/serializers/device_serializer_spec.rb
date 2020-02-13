describe DeviceSerializer do
  let(:device) { create :device }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new device)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
      {
        "data": {
          "id": "#{device.id}",
          "type": "devices",
          "attributes": {
            "created-at": #{device.created_at.to_json},
            "updated-at": #{device.updated_at.to_json},
            "api-key": #{device.api_key.to_json}
          },
          "relationships": {
            "user": {
              "data": {
                "id": "#{device.user_id}",
                "type": "users"
              }
            }
          }
        }
      }
    JSON
  end
end
