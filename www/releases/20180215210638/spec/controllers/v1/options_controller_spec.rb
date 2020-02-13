describe V1::OptionsController do
  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end

  describe '#index' do
    context 'without include param' do
      it 'should return collections of options' do
        get :show

        expect(response).to have_http_status 200

        options = JSON.parse(response.body)
        expect(options['age-range']).to be_instance_of Array
        expect(options['gender']).to be_instance_of Array
      end
    end
  end
end
