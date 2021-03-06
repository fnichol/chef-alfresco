#
# Cookbook Name:: alfresco
# attributes:: mysql_server
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright:: 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.set['mysql']['bind_address'] = "0.0.0.0"


### Platform Package Settings And Defaults

case platform
when "debian","ubuntu"
  node.set['alfresco']['mysql_server']['pkgs']  = %w{make}
else
  node.set['alfresco']['mysql_server']['pkgs']  = []
end
