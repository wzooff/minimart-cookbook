%w(
  epel-release
  nodejs
  git
).each do |pkg|
  package pkg
end

include_recipe 'minimart::_minimart'
include_recipe 'minimart::_repository'
include_recipe 'minimart::_web' if node['minimart']['webserver']['install']
