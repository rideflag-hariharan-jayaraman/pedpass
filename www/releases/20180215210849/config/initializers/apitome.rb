Apitome.setup do |config|
  config.doc_path = 'docs/api'
  config.mount_at = false
  config.readme = '../api.md'
  config.title = 'Pedestrian API Documentation'
end if defined? Apitome
