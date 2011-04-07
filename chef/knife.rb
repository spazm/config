log_level                :info
#log_level                :debug
log_location             STDOUT
node_name                'andrew'
client_key               "#{ENV['HOME']}/.chef/andrew.pem"
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://chef.open42.com:4000'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/Users/andrew/.chef/checksums" )
cookbook_path [ "#{ENV['HOME']}/src/chef-repo/cookbooks", "#{ENV['HOME']}/src/chef-repo/site-cookbooks" ]
