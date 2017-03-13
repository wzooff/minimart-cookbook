default['minimart']['ruby_version'] = '2.3.1'
default['minimart']['path'] = '/opt/minimart'
default['minimart']['url'] = 'http://localhost'

################################################################################
# Parameters for inventory file generation process
# Now it parse github tags and generate inventory.yml
# You should specify list of repos and parse type
# It may be 'web' or 'git'. Last one uses local git client to parse git tags
default['minimart']['repositories']['github_parse'] = 'git'
default['minimart']['repositories']['github'] = {}
# If True, you should manually generate your inventory file in some way
default['minimart']['use_custom_inventory'] = false
################################################################################

# Use web server configuration, provided by cookbook.
# If 'false' - setup your own server or copy 'web' folder where you want (aws for example)
default['minimart']['webserver']['install'] = false
default['minimart']['webserver']['domain'] = 'localhost'

################################################################################
# REMOVE WHEN FIXED: nginx cookbook uses yum::epel recipe, that doesn't exist
default['minimart']['webserver']['install_method'] = 'source'
default['minimart']['webserver']['source']['version'] = '1.2.6'
################################################################################
