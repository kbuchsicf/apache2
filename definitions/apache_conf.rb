#
# Cookbook:: apache2
# Definition:: apache_conf
#
# Copyright:: 2008-2017, Chef Software, Inc.
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

define :apache_conf, enable: true do

  require_relative '../libraries/helpers.rb'
  include_recipe '::default'

  conf_name = "#{params[:name]}.conf"

  params[:conf_path] = if params[:conf_path]
                         params[:conf_path]
                       else
                         "#{apache_dir}/conf-available"
                       end

  file "#{params[:conf_path]}/#{params[:name]}" do
    action :delete
  end

  template "#{params[:conf_path]}/#{conf_name}" do
    source params[:source] || "#{conf_name}.erb"
    cookbook params[:cookbook] if params[:cookbook]
    owner 'root'
    group node['apache']['root_group']
    backup false
    mode '0644'
    notifies :restart, "service[#{node['apache']['service_name']}]", :delayed
    variables(
      apache_dir: apache_dir
    )
  end

  if params[:enable]
    apache_config params[:name] do
      enable true
    end
  end
end
