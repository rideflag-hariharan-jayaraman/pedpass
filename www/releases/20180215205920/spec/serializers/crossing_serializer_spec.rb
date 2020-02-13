describe CrossingSerializer do
  let(:crossing) { create :crossing }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new crossing)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
    {
      "data": {
        "id": "#{crossing.id}",
        "type": "crossings",
        "attributes": {
          "created-at": #{crossing.created_at.to_json},
          "updated-at": #{crossing.updated_at.to_json},
          "success": true,
          "message": null
        },
        "relationships": {
          "crosswalk": {
            "data": {
              "id": "#{crossing.crosswalk_id}",
              "type": "crosswalks"
            }
          },
          "user": {
            "data": {
              "id": "#{crossing.user_id}",
              "type": "users"
            }
          }
        }
      }
    }
    JSON
  end
end
