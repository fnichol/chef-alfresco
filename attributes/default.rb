# Alfresco components that are not enabled by default:
# analytics - Alfresco Reporting and Analytics feature; enterprise-only
# aos - Alfresco Office Services (WARs); enterprise-only
# media - Alfresco media-management; enterprise-only
# rsyslog - Remote logging
# logstash-forwarder - Remote logging
#
# Default Alfresco components
#
default['alfresco']['components'] = ['haproxy','nginx','tomcat','transform','repo','share','solr','mysql','rm','googledocs','yourkit']

# See .kitchen.yml
# default['alfresco']['s3_databag'] = ""
# default['alfresco']['s3_databag_item'] = ""
# default['alfresco']['hz_share_databag'] = ""
# default['alfresco']['hz_share_databag_item'] = ""
# default["alfresco"]["jmxremote_databag"] = "credentials"
# default["alfresco"]["jmxremote_databag_items"] = ["systemsmonitor", "systemscontrol"]
# default["alfresco"]["mailsmtp_databag"] = "credentials"
# default["alfresco"]["mailsmtp_databag_item"] = "outbound-email"

# New ones
default['alfresco']['internal_hostname'] = "127.0.0.1"
default['alfresco']['internal_port'] = "9000"
default['alfresco']['internal_portssl'] = "9443"
default['alfresco']['internal_protocol'] = "http"

default['alfresco']['public_hostname'] = "localhost"
default['alfresco']['public_port'] = "80"
default['alfresco']['public_portssl'] = "443"
default['alfresco']['public_protocol'] = "https"

default['alfresco']['rmi_server_hostname'] = node['alfresco']['public_hostname']

# Alfresco version; you can use Enterprise versions, ie. '5.0.1'
default['alfresco']['groupId'] = "org.alfresco"
default['alfresco']['version'] = "5.1.b-EA"
default['alfresco']['edition'] = "community"

default['alfresco']['home'] = "/usr/share/tomcat"
default['alfresco']['user'] = "tomcat"

default['alfresco']['skip_certificate_creation'] = false

# Use log4j json as output
default['alfresco']['log.json.enabled'] = false

# Patch alfresco web.xml to disable SSL restrictions and use secureComms=none
default['alfresco']['enable.web.xml.nossl.patch'] = true

#Generates alfresco-global.properties using all node['alfresco']['properties'] key/value attributes
default['alfresco']['generate.global.properties'] = true

#Generates share-config-custom.xml using a pre-defined template (check templates/default) and configuring http endpoint and disabling CSRF
default['alfresco']['generate.share.config.custom'] = true

default['alfresco']['generate.solr.core.config'] = true

#Generates repo-log4j.properties using all node['alfresco']['repo-log4j'] key/value attributes
default['alfresco']['generate.repo.log4j.properties'] = true

#Patches an existing share-config-custom.xml using node['alfresco']['properties'] key/value attributes and replacing all @@key@@ occurrencies
#Note! To enable this, you must provide your own share-config-custom.xml in
# #{node['alfresco']['shared']}/classes/alfresco/web-extension/share-config-custom.xml
default['alfresco']['patch.share.config.custom'] = false

#License defaults
default['alfresco']['license_source'] = 'alfresco-license'
default['alfresco']['license_cookbook'] = 'alfresco'

# Using Alfresco Nexus public by default (in case databags aren't in place)
default['artifact-deployer']['maven']['repositories']['public']['url'] = "https://artifacts.alfresco.com/nexus/content/groups/public"

#Mysql defaults
default['mysql']['update_gcc'] = true

# Java defaults
default["java"]["default"] = true
default["java"]["accept_license_agreement"] = true
default["java"]["install_flavor"] = "oracle"
default["java"]["jdk_version"] = "8"
default["java"]["java_home"] = "/usr/lib/jvm/java"
default["java"]["oracle"]['accept_oracle_download_terms']  = true

default['java']['jdk']['8']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz'
default['java']['jdk']['8']['x86_64']['checksum'] = '88f31f3d642c3287134297b8c10e61bf'

#3rd-party defaults
default['alfresco']['install_fonts'] = true
# Exclude chkfontpath due to unsatisfied dependency on xfs
default['alfresco']['exclude_font_packages'] = "tv-fonts chkfontpath pagul-fonts\*"

default['logging']['log4j.rootLogger'] = "warn, File"
# No need for console logs, just dump to file
# default['logging']['log4j.appender.Console'] = "org.apache.log4j.DailyRollingFileAppender"
# default['logging']['log4j.appender.Console.layout'] = "org.apache.log4j.PatternLayout"
# default['logging']['log4j.appender.Console.layout.ConversionPattern'] = "%d{ISO8601} %x %-5p [%c{3}] [%t] %m%n"
# default['logging']['log4j.appender.Console.layout.ConversionPattern'] = "%d{ISO8601} %-5p [%c] %m%n"
default['logging']['log4j.appender.File'] = "org.apache.log4j.DailyRollingFileAppender"
default['logging']['log4j.appender.File.Append'] = "true"
default['logging']['log4j.appender.File.DatePattern'] = "'.'yyyy-MM-dd"
default['logging']['log4j.appender.File.layout'] = "org.apache.log4j.PatternLayout"
default['logging']['log4j.appender.File.layout.ConversionPattern'] = "%d{ABSOLUTE} %-5p [%c] %m%n"
default['logging']['log4j.appender.File.File'] = "${logfilename}"

# DB params shared between client and server
default['alfresco']['db']['server_root_password'] = 'alfresco'
default['alfresco']['db']['root_user'] = "root"

# Alfresco services configuration
default["alfresco"]["start_service"] = true
default['alfresco']['restart_services'] = ['tomcat-alfresco','tomcat-share','tomcat-solr']
default['alfresco']['restart_action']   = [:enable, :restart]
