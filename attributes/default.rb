default['minimart']['ruby_version'] = '2.3.1'
default['minimart']['path'] = '/opt/minimart'
default['minimart']['url'] = 'http://localhost'
default['minimart']['repositories']['github'] = {}

# Use web server configuration, provided by cookbook.
# If 'false' - setup your own server or copy 'web' folder where you want (aws for example)
default['minimart']['webserver']['install'] = false
default['minimart']['webserver']['domain'] = 'localhost'
###############################################################################
# REMOVE WHEN FIXED: nginx cookbook uses yum::epel recipe, that doesn't exist
default['minimart']['webserver']['install_method'] = 'source'
default['minimart']['webserver']['source']['version'] = '1.2.6'
###############################################################################
