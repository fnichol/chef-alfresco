ssl_folder = node['nginx']['ssl_folder']
ssl_folder_source = node['nginx']['ssl_folder_source']
ssl_folder_cookbook = node['nginx']['ssl_folder_cookbook']

# Override config values, if ssl is disabled
if node['nginx']['use_nossl_config']
  node.set['nginx']['config'] = node['nginx']['nossl_config']
end

# Delete Centos default configuration
# Replaced by /etc/nginx/sites-enabled/*
file "/etc/nginx/conf.d/default.conf" do
  action :delete
end

if node['nginx']['logging_json_enabled']
  node.default['nginx']['logging'] =   "    log_format  main  '$remote_addr - $remote_user [$time_local] \"$request\" '",
    "                      '$status $body_bytes_sent \"$http_referer\" '",
    "                      '\"$http_user_agent\" \"$http_x_forwarded_for\"';"
end

include_recipe 'alfresco::_certs'
include_recipe 'alfresco::_errorpages'

directory ssl_folder do
  action :create
  recursive true
end

remote_directory ssl_folder do
  source ssl_folder_source
  cookbook ssl_folder_cookbook
end

# nginx::repo must be explicitely called, to install nginx yum repos
# and get the latest package versions
include_recipe 'nginx::repo'

include_recipe 'nginx::default'

# Fixing nginx cookbook by overriding service actions and disabling/stopping it
service_actions = node['nginx']['service_actions']
r = resources(service: 'nginx')
r.action(service_actions)
