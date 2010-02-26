
# test grabbing data from ganglia to use for generating config in chef.

# get_hosts_for_metric("df_")

$:<< File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'rubygems'
require 'dust'

require 'ganglia'
GMOND_HOST='localhost'
GMOND_PORT=8649

unit_tests do


end