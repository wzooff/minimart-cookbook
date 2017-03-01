include_recipe 'ruby_rbenv::system_install'
include_recipe 'ruby_build'
rbenv_ruby node['minimart']['ruby_version']
rbenv_global node['minimart']['ruby_version']
rbenv_gem 'minimart'
rbenv_gem 'execjs'
# %w(
#   execjs
#   minimart
# ).each do |gemp|
#   rbenv_gem gemp do
#     ruby_version '2.3.1'
#   end
# end

directory node['minimart']['path'] do
  owner 'nginx'
  group 'nginx'
  mode 00755
  recursive true
  action :create
end
