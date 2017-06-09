# Additional Alfresco paths
node.default['alfresco']['bin'] = "#{node['alfresco']['home']}/bin"
node.default['alfresco']['shared'] = "#{node['alfresco']['home']}/shared"
node.default['alfresco']['shared_lib'] = "#{node['alfresco']['shared']}/lib"
node.default['alfresco']['amps_folder'] = "#{node['alfresco']['home']}/amps"
node.default['alfresco']['amps_share_folder'] = "#{node['alfresco']['home']}/amps_share"

node.default['alfresco']['server_info'] = "Alfresco (#{node['alfresco']['public_hostname']})"

# Use JSON with log4j, if enabled
if node['alfresco']['log.json.enabled']
  node.default['artifacts']['json-logging-repo-amp']['enabled'] = true
  node.default['artifacts']['json-logging-share-amp']['enabled'] = true
  node.default['logging']['log4j.appender.File.layout'] = "net.logstash.log4j.JSONEventLayoutV1"
  node.default['logging']['log4j.appender.File.File'] = "${logfilename}.json"
  node.default['logstash-forwarder']['items']['alfresco-repo']['paths'] = ['/var/log/tomcat-alfresco/alfresco.log.json']
  node.default['logstash-forwarder']['items']['alfresco-share']['paths'] = ['/var/log/tomcat-share/share.log.json']
  node.default['logstash-forwarder']['items']['alfresco-solr']['paths'] = ['/var/log/tomcat-solr/solr.log.json']
end
node.default['alfresco']['log4j'] = node['logging']

mailsmtp_databag = node["alfresco"]["mailsmtp_databag"]
mailsmtp_databag_items = node["alfresco"]["mailsmtp_databag_items"]

begin
  db_item = data_bag_item(mailsmtp_databag,mailsmtp_databag_item)
  node.default['alfresco']['properties']['mail.username'] = db_item['username']
  node.default['alfresco']['properties']['mail.password'] = db_item['password']
rescue
  Chef::Log.warn("Error fetching databag #{mailsmtp_databag}, item #{mailsmtp_databag_items}")
end

#JMX host
node.default['alfresco']['properties']['hostname.public'] = node['alfresco']['public_hostname']
node.default['alfresco']['properties']['hostname.private'] = node['alfresco']['internal_hostname']

#Email
node.default['alfresco']['properties']['mail.from.default'] = "webmaster@#{node['alfresco']['public_hostname']}"

#Search Config
node.default['alfresco']['properties']['solr.host'] = node['alfresco']['internal_hostname']
node.default['alfresco']['properties']['solr.port'] = node['alfresco']['internal_port']
node.default['alfresco']['properties']['solr.port.ssl'] = node['alfresco']['internal_portssl']

# Alfresco params
node.default['alfresco']['properties']['alfresco.host'] = node['alfresco']['public_hostname']
node.default['alfresco']['properties']['alfresco.port.ssl'] = node['alfresco']['public_portssl']
node.default['alfresco']['properties']['alfresco.protocol'] = node['alfresco']['public_protocol']
node.default['alfresco']['properties']['alfresco.port'] = node['alfresco']['public_portssl']

#Share Public Endpoint
node.default['alfresco']['properties']['share.host'] = node['alfresco']['public_hostname']
node.default['alfresco']['properties']['share.port'] = node['alfresco']['public_portssl']
node.default['alfresco']['properties']['share.protocol'] = node['alfresco']['public_protocol']

# OpenCMIS
node.default['alfresco']['properties']['opencmis.server.host'] = node['alfresco']['public_hostname']
node.default['alfresco']['properties']['opencmis.server.protocol'] = node['alfresco']['public_protocol']

# AOS
node.default['alfresco']['properties']['aos.baseProtocol'] = node['alfresco']['public_protocol']
node.default['alfresco']['properties']['aos.baseHost'] = node['alfresco']['public_hostname']
node.default['alfresco']['properties']['aos.port'] = node['alfresco']['public_port']
