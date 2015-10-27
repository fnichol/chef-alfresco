# TODO - Tomcat users should be created by tomcat_instance resource, not via recipe
# include_recipe "tomcat::users"

node.default['artifacts']['alfresco-mmt']['enabled'] = true
node.default['artifacts']['sharedclasses']['enabled'] = true
node.default['artifacts']['catalina-jmx']['enabled'] = true

context_template_cookbook = node['tomcat']['context_template_cookbook']
context_template_source = node['tomcat']['context_template_source']

additional_tomcat_packages = node['tomcat']['additional_tomcat_packages']
additional_tomcat_packages.each do |pkg|
  package pkg do
    action :install
  end
end

jmxremote_databag = node["alfresco"]["jmxremote_databag"]
jmxremote_databag_items = node["alfresco"]["jmxremote_databag_items"]

begin
  jmxremote_databag_items.each do |jmxremote_databag_item|
    db_item = data_bag_item(jmxremote_databag,jmxremote_databag_item)
    node.default["tomcat"]["jmxremote_#{jmxremote_databag_item}_role"] = db_item['username']
    node.default["tomcat"]["jmxremote_#{jmxremote_databag_item}_password"] = db_item['password']
    node.default["tomcat"]["jmxremote_#{jmxremote_databag_item}_access"] = db_item['access']
  end
rescue
  Chef::Log.warn("Error fetching databag #{jmxremote_databag},  item #{jmxremote_databag_items}")
end

include_recipe 'tomcat::default'

template "#{node['alfresco']['home']}/conf/context.xml" do
  cookbook context_template_cookbook
  source context_template_source
  owner node['alfresco']['user']
  group node['tomcat']['group']
end

file_replace_line 'patch-tomcat-conf-javahome' do
  path      '/etc/tomcat/tomcat.conf'
  replace   "JAVA_HOME="
  with      "JAVA_HOME=#{node['java']['java_home']}"
  not_if    "cat /etc/tomcat/tomcat.conf | grep 'JAVA_HOME=#{node['java']['java_home']}'"
end

file_replace_line 'patch-tomcat-conf-tmpdir' do
  path      '/etc/tomcat/tomcat.conf'
  replace   "CATALINA_TMPDIR="
  with      "#CATALINA_TMPDIR="
  not_if    "cat /etc/tomcat/tomcat.conf | grep '#CATALINA_TMPDIR="
end
