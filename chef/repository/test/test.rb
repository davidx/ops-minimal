
$:<< File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'rubygems'
require 'dust'
require 'xmlsimple'
require 'socket'
require 'json'
require 'ganglia'

GMOND_HOST='localhost'
GMOND_PORT=8649


unit_tests do
 include Ganglia
  test "connect to socket" do
    assert_nothing_raised do
     t = TCPSocket.new(GMOND_HOST, GMOND_PORT);
     t.close
    end
  end

  test "get data from socket" do
    t = TCPSocket.new(GMOND_HOST, GMOND_PORT)
    assert_not_nil t
    assert t.kind_of?(TCPSocket)
    answer = t.gets(nil)
    t.close
    assert_not_nil answer
    assert_kind_of String, answer
  end
  test "get gmond xml" do
    xml = Ganglia.get_gmond_xml(GMOND_HOST, GMOND_PORT)
    assert_kind_of String, xml
    assert xml.length > 0
    assert_not_nil xml
    assert_kind_of String, xml
    assert xml.length > 0
  end
  test "parse xml into hash" do
    xml = Ganglia.get_gmond_xml(GMOND_HOST, GMOND_PORT)
    assert_kind_of String, xml
    assert xml.length > 0
    assert_not_nil xml
    assert_kind_of String, xml
    assert xml.length > 0
    data = XmlSimple.xml_in(xml)
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.keys.length > 0
  end
  test "parse gmond xml" do
    xml = Ganglia.get_gmond_xml(GMOND_HOST, GMOND_PORT)
    assert_kind_of String, xml
    assert xml.length > 0
    assert_not_nil xml
    assert_kind_of String, xml
    assert xml.length > 0
    data = Ganglia.parse_gmond_xml(xml)
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.keys.length > 0
  end
  test "get gmond data" do
    xml = Ganglia.get_gmond_xml(GMOND_HOST, GMOND_PORT)
    data2 = Ganglia.get_gmond_data(GMOND_HOST, GMOND_PORT)

    assert_kind_of String, xml
    assert xml.length > 0
    assert_not_nil xml
    assert_kind_of String, xml
    assert xml.length > 0
    data = Ganglia.parse_gmond_xml(xml)
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.keys.length > 0
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.keys.length > 0
    assert_equal data.keys.first, data2.keys.first, "not the same" 
  end
  test "check gmond data sanity" do
    data = Ganglia.get_gmond_data(GMOND_HOST, GMOND_PORT)
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.keys.length > 0
    assert data.key?('CLUSTER')
    assert data['CLUSTER'].first.key?('HOST')
    assert data['CLUSTER'][0]['HOST'].kind_of?(Array)
    assert data['CLUSTER'][0]['HOST'].length > 0
    assert_not_nil data['CLUSTER'][0]['HOST'].first['NAME']
    assert_kind_of String, data['CLUSTER'][0]['HOST'].first['NAME']
    assert data['CLUSTER'][0]['HOST'].first['NAME'].length > 0

  end
  test "get hosts with metrics" do
    hosts = Ganglia.hosts_with_metric("load_one")
    assert_not_nil hosts
    assert_kind_of Array, hosts
    assert hosts.length > 0
    nohosts =  Ganglia.hosts_with_metric("doesntexist")
    assert_not_nil nohosts
    assert_kind_of Array, nohosts   
    assert nohosts.length == 0
  end
  test "get metrics for name" do
     metrics = Ganglia.metrics_with_string("df_")
     assert_not_nil metrics
     assert_kind_of Hash, metrics
     assert metrics.keys.length > 0
   end


end
