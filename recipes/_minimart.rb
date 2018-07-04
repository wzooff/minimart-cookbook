rbenv_system_install 'install rbenv globally'
include_recipe 'ruby_build'
rbenv_ruby node['minimart']['ruby_version']
rbenv_global node['minimart']['ruby_version']

%w(
  gcc-c++
).each do |pkg|
  package pkg
end

rbenv_gem 'minimart' do
  rbenv_version node['minimart']['ruby_version']
end

rbenv_gem 'execjs' do
  rbenv_version node['minimart']['ruby_version']
end

directory node['minimart']['path'] do
  mode 00755
  recursive true
  action :create
end
