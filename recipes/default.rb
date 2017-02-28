##########
# Install
##########

%w(nodejs).each do |pkg|
  package pkg
end

include_recipe 'ruby_rbenv::system_install'
include_recipe 'ruby_build'
rbenv_ruby node['minimart']['ruby_version']
rbenv_global node['minimart']['ruby_version']
rbenv_gem 'minimart' do
  action :install
end

directory node['minimart']['path'] do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

%w(
  execjs
  minimart
).each do |gemp|
  gem_package gemp do
    action :install
  end
end

############
# Configure
############

execute 'init repository' do
  command 'minimart init'
  cwd node['minimart']['path']
  action :run
end
