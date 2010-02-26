
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
 test "get metrics" do
   hosts = Ganglia.hosts_with_metric("load_one")
   assert_not_nil hosts
   assert_kind_of Array, hosts
   assert hosts.length > 0
   nohosts =  Ganglia.hosts_with_metric("doesntexist")
   assert_not_nil nohosts
   assert_kind_of Array, nohosts   
   assert nohosts.length == 0
 end

  


end