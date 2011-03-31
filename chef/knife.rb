log_level                :info
log_location             STDOUT
node_name                'andrew'
client_key               '/Users/andrew/.chef/andrew.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://chef.open42.com'
cache_type               'BasicFile'
cache_options( :path => '/Users/andrew/.chef/checksums' )
cookbook_path [ '/home/andrew/src/chef-repo/cookbooks', '/home/andrew/src/chef-repo/site-cookbooks' ]
