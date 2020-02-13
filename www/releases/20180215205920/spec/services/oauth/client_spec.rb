describe Oauth::Client do
  describe '#auth_client' do
    context 'with facebook provider' do
      subject { Oauth::Client.new('facebook', 'random_token').auth_client }
      it { should be_instance_of(Oauth::Facebook) }
    end
  end

  describe '#fetch' do
    context 'with invalid token' do
      subject { -> { Oauth::Client.new('facebook', 'random_token').fetch } }
      it { is_expected.to raise_error(Oauth::ConnectionError) }
    end

    context 'with valid token' do
      before do
        allow_any_instance_of(Koala::Facebook::API)
        .to receive(:get_object)
        .and_return(JSON.parse({
          email: 'user@example.com', age_range: { min: 20, max: 23 }, gender: 'male'
        }.to_json))
      end
      subject { Oauth::Client.new('facebook', 'some invalid token').fetch }

      it { should be_instance_of OpenStruct }
      it { should respond_to(:email, :age, :gender) }
    end
  end
end
