module V1
  class OptionsController < V1::BaseController
    skip_before_action :authenticate_user_from_token!

    def show
      render json: {
        'age-range': age_range,
        gender: gender,
        'beacon-update-rate': Setting.beacon_update_rate || 1000
      }
    end

    def age_range
      AgeRange.map { |ar| { code: ar.to_s, label: ar.text } }
    end

    def gender
      Gender.map { |g| { code: g.to_s, label: g.text } }
    end
  end
end
