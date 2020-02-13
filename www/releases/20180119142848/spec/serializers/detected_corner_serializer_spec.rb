describe DetectedCornerSerializer do
  let(:detected_corner) { create :detected_corner }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new detected_corner)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
      {
        "data": {
          "id": "#{detected_corner.id}",
          "type": "detected-corners",
          "attributes": {
            "created-at": #{detected_corner.created_at.to_json},
            "updated-at": #{detected_corner.updated_at.to_json},
            "beacon-proximity": #{detected_corner.beacon_proximity.to_json},
            "beacon-distance": #{detected_corner.beacon_distance.to_json},
            "latitude": #{detected_corner.latitude.to_json},
            "longitude": #{detected_corner.longitude.to_json},
            "accuracy": #{detected_corner.accuracy.to_json},
            "heading": #{detected_corner.heading.to_json},
            "speed": #{detected_corner.speed.to_json}
          },
          "relationships": {
            "crossings": {
              "data": []
            },
            "corner": {
              "data": {
                "id": "#{detected_corner.corner_id.to_json}",
                "type": "corners"
              }
            }
          }
        }
      }
    JSON
  end
end
