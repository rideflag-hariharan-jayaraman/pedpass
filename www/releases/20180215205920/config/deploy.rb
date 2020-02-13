lock '3.8.1'

set :application, 'pedestrian-web'
set :repo_url, 'git@bitbucket.org:devbbq/pedestrian-web.git'

set :log_level, :info
set :assets_roles, [:puma_role]

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
