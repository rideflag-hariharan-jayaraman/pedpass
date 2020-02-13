describe CornerSerializer do
  let(:corner) { create :corner }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new corner)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
      {
        "data": {
          "id": "#{corner.id}",
          "type": "corners",
          "attributes": {
            "created-at": #{corner.created_at.to_json},
            "updated-at": #{corner.updated_at.to_json},
            "longitude": #{corner.longitude.to_json},
            "latitude": #{corner.latitude.to_json}
          }
        }
      }
    JSON
  end
end
