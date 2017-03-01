%w(
  epel-release
  nodejs
  nginx
).each do |pkg|
  package pkg
end

include_recipe 'minimart::_web'
include_recipe 'minimart::_minimart'
include_recipe 'minimart::_repository'
