module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authentication_check unless Rails.env.development?

    private
    def authentication_check
      authenticate_or_request_with_http_basic do |user, password|
        (user == Rails.application.secrets.admin_username && password == Rails.application.secrets.admin_password) \
        || (user == 'judvardy' && password == 'rideflagju') \
        || (user == 'jcedero' && password == 'rideflagjc') \
        || (user == 'jwilcox' && password == 'rideflagjw') \
        || (user == 'mpapineau' && password == 'rideflagmp')
      end
    end
  end
end
