require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.api_name = 'Pedestrian API'
  config.curl_headers_to_filter = %w(Cookie Host)
  config.curl_host = 'http://localhost:300'
  config.docs_dir = Rails.root.join("docs", "api")
  config.format = [:json]
  config.request_headers_to_include = %w[Content-Type Token]
  config.response_headers_to_include = %w[Content-Type]
end
