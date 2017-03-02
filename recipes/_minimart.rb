include_recipe 'ruby_rbenv::system_install'
include_recipe 'ruby_build'
rbenv_ruby node['minimart']['ruby_version']
rbenv_global node['minimart']['ruby_version']
rbenv_gem 'minimart'
rbenv_gem 'execjs'

directory node['minimart']['path'] do
  mode 00755
  recursive true
  action :create
end
