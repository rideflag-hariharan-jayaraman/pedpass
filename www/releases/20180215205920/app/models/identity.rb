class Identity < ApplicationRecord
  PROVIDERS = %w(facebook).freeze

  belongs_to :user

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  # Given an auth client, we'll create a new user
  #
  # @param [OAuth::Client]
  # @return [User]
  def self.user_from_omniauth(auth_client)
    user_info = auth_client.fetch

    user = User.new(
      email: user_info.email, password: Devise.friendly_token[0, 20]
    )
    user.build_profile(
      gender: user_info.gender,
      age_range: AgeRange.get_from_age(user_info.age.to_i),
    )
    user.identities.build(provider: auth_client.provider, uid: auth_client.token)

    user.skip_confirmation!
    user.save!

    user
  end
end
