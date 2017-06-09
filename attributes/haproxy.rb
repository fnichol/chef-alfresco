default['haproxy']['enabled_backends'] = ['alfresco','solr','share','aos_root','aos_vti']

# Force rsyslog to use UDP on localhost
default['haproxy']['enable_rsyslog_server'] = true
default['haproxy']['rsyslog_bind'] = "127.0.0.1"

# HAproxy cookbook attributes
default['haproxy']['enable_ssl'] = false
default['haproxy']['enable_admin'] = false
default['haproxy']['enable_default_http'] = false

default['haproxy']['enable.ec2.discovery'] = false

default['haproxy']['conf_cookbook'] = 'alfresco'
default['haproxy']['conf_template_source'] = 'haproxy/haproxy.cfg.erb'

default['haproxy']['bind_ip'] = "127.0.0.1"
default['haproxy']['default_backend'] = "share"
default['haproxy']['stats_port'] = "1936"
default['haproxy']['stats_auth'] = "admin"
default['haproxy']['stats_pwd'] = "changeme"


default['haproxy']['acls'] = ["is_root path_reg ^$|^/$"]

default['haproxy']['redirects'] = [
  "redirect location /share/ if !is_share !is_alfresco !is_solr !is_aos_root !is_aos_vti",
  "redirect location /share/ if is_root"
]

default['haproxy']['ssl_chain_file'] = "#{node['alfresco']['certs']['ssl_folder']}/#{node['alfresco']['certs']['filename']}.chain"

default['haproxy']['general_config'] = [
  "# -- global settings section --",
  "global",
  "tune.ssl.default-dh-param 2048",
  # Logging should be handled with logstash-forwarder
  "log 127.0.0.1 local2 info",
  "pidfile /var/run/haproxy.pid",
  "stats socket /var/run/haproxy.stat user haproxy group haproxy mode 600 level admin",
  "user haproxy",
  "group haproxy",
  "tune.ssl.maxrecord 1419",
  "spread-checks 5",
  "# -- defaults settings section --",
  "defaults",
  "mode http",
  "log global",
  "retries 3",
  "# Options",
  "option httplog",
  "option dontlognull",
  "option forwardfor",
  "option http-server-close",
  "option redispatch",
  "#optimisations",
  "option tcp-smart-accept",
  "option tcp-smart-connect",
  "option contstats",
  "# Timeouts",
  "timeout http-request 10s",
  "timeout queue 1m",
  "timeout connect 5s",
  "timeout client 2m",
  "timeout server 2m",
  "timeout http-keep-alive 10s",
  "timeout check 5s",
  "timeout tarpit 60s",
  "compression algo gzip",
  "compression type text/html text/html;charset=utf-8 text/plain text/css text/javascript application/x-javascript application/javascript application/ecmascript application/rss+xml application/atomsvc+xml application/atom+xml application/atom+xml;type=entry application/atom+xml;type=feed application/cmisquery+xml application/cmisallowableactions+xml application/cmisatom+xml application/cmistree+xml application/cmisacl+xml application/msword application/vnd.ms-excel application/vnd.ms-powerpoint application/json",
]

default['haproxy']['frontends']['http']['entries'] = [
  "mode http",
  "bind #{node['haproxy']['bind_ip']}:#{node['alfresco']['internal_port']}",
  # Force HTTPS
  # "redirect scheme https if !{ ssl_fc }",
  # TODO - still not working
  # "bind #{node['haproxy']['bind_ip']}:#{node['alfresco']['internal_portssl']} ssl crt #{node['haproxy']['ssl_chain_file']}",
  "capture request header X-Forwarded-For len 64",
  "capture request header User-agent len 256",
  "capture request header Cookie len 64",
  "capture request header Accept-Language len 64"
]

default['haproxy']['frontends']['stats']['entries'] = [
  "bind #{node['haproxy']['bind_ip']}:#{node['haproxy']['stats_port']}",
  "http-request set-log-level silent",
  "stats enable",
  "stats hide-version",
  "stats realm Haproxy\ Statistics",
  "stats uri /",
  "stats auth #{node['haproxy']['stats_auth']}:#{node['haproxy']['stats_pwd']}",
  "stats refresh   2s",
]

# Share Haproxy configuration
# Note: the haproxy backend items are configured on each sub recipe: repo.rb, share.rb and solr.rb
default['haproxy']['share_stats_auth'] = "admin:password"
default['haproxy']['frontends']['http']['acls']['share']= ['path_beg /share']
default['haproxy']['backends']['share']['entries'] = [
  "rspirep ^Location:\\s*http://.*?\.#{node['alfresco']['public_hostname']}(/.*)$ Location:\\ \\1",
  "rspirep ^Location:(.*\\?\w+=)http(%3a%2f%2f.*?\\.#{node['alfresco']['public_hostname']}%2f.*)$ Location:\\ \\1https\\2",
  "acl secured_cookie res.hdr(Set-Cookie),lower -m sub secure",
  "rspirep ^(set-cookie:.*) \\1;\\ Secure if !secured_cookie",
  "rspdel Expires\\=Thu\\,\\ 01\-Jan\\-1970\\ 00\\:00\\:10\\ GMT",
  "reqdel Expires\\=Thu\\,\\ 01\-Jan\\-1970\\ 00\\:00\\:10\\ GMT",
  "option httpchk GET /share",
  "balance leastconn",
  "cookie JSESSIONID prefix",
  "tcp-request inspect-delay 5s",
  "capture request header X-Forwarded-For len 64",
  "acl HAS_X_FORWARDED_FOR hdr_cnt(X-Forwarded-For) eq 1",
  "acl HAS_JSESSIONID hdr_sub(cookie) JSESSIONID",
  "tcp-request content track-sc0 hdr_ip(X-Forwarded-For,-1) if HTTP HAS_X_FORWARDED_FOR !HAS_JSESSIONID",
  "http-request tarpit if { src_conn_cur ge 5 }",
  "connections in 5 seconds",
  "http-request tarpit if { src_conn_rate ge 20 }",
  "http-request tarpit if { sc0_http_err_rate() gt 5 }",
  "http-request tarpit if { sc0_http_req_rate() gt 20 }",
  "acl FORBIDDEN_HDR hdr_cnt(host) gt 1",
  "acl FORBIDDEN_HDR hdr_cnt(content-length) gt 1",
  "acl FORBIDDEN_HDR hdr_val(content-length) lt 0",
  "acl FORBIDDEN_HDR hdr_cnt(proxy-authorization) gt 0",
  "acl FORBIDDEN_HDR hdr_cnt(x-xsrf-token) gt 1",
  "acl FORBIDDEN_HDR hdr_len(x-xsrf-token) gt 36",
  "acl FORBIDDEN_HDR hdr_cnt(X-Forwarded-For) gt 3",
  "http-request tarpit if FORBIDDEN_HDR",
  "acl WEIRD_RANGE_HEADERS hdr_cnt(Range) gt 10",
  "http-request tarpit if WEIRD_RANGE_HEADERS",
  "rspadd Strict-Transport-Security:\ max-age=15768000"
]

default['haproxy']['backends']['share']['port'] = 8081

# Solr Haproxy configuration
default['haproxy']['frontends']['http']['acls']['solr'] = ['path_beg /solr4']
default['haproxy']['backends']['solr']['entries'] = ["option httpchk GET /solr4","cookie JSESSIONID prefix","balance url_param JSESSIONID check_post"]
default['haproxy']['backends']['solr']['port'] = 8090

# HAproxy configuration
default['haproxy']['frontends']['http']['acls']['alfresco'] = ["path_beg /alfresco", "path_reg ^/alfresco/aos/.*","path_reg ^/alfresco/aos$"]
default['haproxy']['backends']['alfresco']['entries'] = ["option httpchk GET /alfresco","cookie JSESSIONID prefix","balance url_param JSESSIONID check_post"]
default['haproxy']['backends']['alfresco']['port'] = 8070

default['haproxy']['frontends']['http']['acls']['aos_vti'] = ["path_reg ^/_vti_inf.html$","path_reg ^/_vti_bin/.*"]
default['haproxy']['backends']['aos_vti']['entries'] = ["option httpchk GET /_vti_inf.html","cookie JSESSIONID prefix","balance url_param JSESSIONID check_post"]
default['haproxy']['backends']['aos_vti']['port'] = 8070

default['haproxy']['frontends']['http']['acls']['aos_root'] = ["path_reg ^/$ method OPTIONS","path_reg ^/$ method PROPFIND"]
default['haproxy']['backends']['aos_root']['entries'] = ["option httpchk GET /","cookie JSESSIONID prefix","balance url_param JSESSIONID check_post"]
default['haproxy']['backends']['aos_root']['port'] = 8070
