describe CrosswalkSerializer do
  let(:crosswalk) { create :crosswalk }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new crosswalk)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
      {
        "data": {
          "id": "#{crosswalk.id}",
          "type": "crosswalks",
          "attributes": {
            "created-at": #{crosswalk.created_at.to_json},
            "updated-at": #{crosswalk.updated_at.to_json},
            "location": null
          },
          "relationships": {
            "corners": {
              "data": []
            }
          }
        }
      }
    JSON
  end
end
