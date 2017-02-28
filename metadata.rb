name             'minimart'
maintainer       'Andrii Veklychev'
maintainer_email 'wzooff@gmail.com'
license          'All rights reserved'
description      'Installs/Configures minimart supermarket'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
source_url       'https://github.com/wzooff/minimart-cookbook'
issues_url       'https://github.com/wzooff/minimart-cookbook/issues'
chef_version     '>= 12.1'

depends 'ruby_rbenv', '~> 1.1.0'
depends 'ruby_build'

%w(centos).each do |os|
  supports os
end
