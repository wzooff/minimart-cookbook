default['minimart']['ruby_version'] = '2.3.1'
default['minimart']['path'] = '/opt/minimart'
default['minimart']['url'] = 'http://localhost'
default['minimart']['repositories']['github'] = {
  minimart: 'wzooff/minimart-cookbook',
  chef_nginx: 'chef-cookbooks/chef_nginx'
}

default['nginx']['install_method'] = 'source' # because of nginx cookbook uses yum::epel recipe, that doesnt exist
default['nginx']['source']['version'] = '1.2.6'
