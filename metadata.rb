name             'minimart'
maintainer       'Andrii Veklychev'
maintainer_email 'wzooff@gmail.com'
license          'All rights reserved'
description      'Installs/Configures minimart supermarket'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'
source_url       'https://github.com/wzooff/minimart-cookbook'
issues_url       'https://github.com/wzooff/minimart-cookbook/issues'
chef_version     '>= 12.1'

depends 'ruby_rbenv'
depends 'ruby_build'

gem 'git'

%w(centos).each do |os|
  supports os
end

recipe 'minimart::default', 'Install everything :)'
recipe 'minimart::_minimart', 'Install minimart supermarket gem and dependencies'
recipe 'minimart::_repository', 'Configures, creates repository and fetch cookbooks'
recipe 'minimart::_web', 'Configures Nginx as a server for supermarket'
