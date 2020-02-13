describe UserSerializer do
  let(:user) { create :user }
  subject do
    ActiveModelSerializers::Adapter::JsonApi.new(described_class.new user)
  end

  its(:to_json) do
    should eql <<~JSON.gsub(/\s+/, '')
      {
        "data": {
          "id": "#{user.id}",
          "type": "users",
          "attributes": {
            "created-at": #{user.created_at.to_json},
            "updated-at": #{user.updated_at.to_json}
          },
          "relationships": {
            "devices": {
              "data": []
            }
          }
        }
      }
    JSON
  end
end
