FactoryBot.define do
  factory :device do
    uuid { Digest::MD5.new.update SecureRandom.uuid }

    user
  end
end
