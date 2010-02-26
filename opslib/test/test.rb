
$:<< File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'rubygems'
require 'dust'
require 'xmlsimple'
require 'socket'
require 'gmond'

GMOND_HOST='localhost'
GMOND_PORT=8649

unit_tests do
  test "create instance" do
    g = Gmond.new(GMOND_HOST,GMOND_PORT)
    assert_not_nil g
    assert_kind_of Gmond, g
  end
  test "get data" do
    g = Gmond.new(GMOND_HOST,GMOND_PORT)
    data = g.get_data
    assert_not_nil data
    assert_kind_of Hash, data
    assert data.key?('CLUSTER')
    assert data['CLUSTER'].first.key?('HOST')
    assert data['CLUSTER'][0]['HOST'].kind_of?(Array)
    assert data['CLUSTER'][0]['HOST'].length > 0
    assert_not_nil data['CLUSTER'][0]['HOST'].first['NAME']
    assert_kind_of String, data['CLUSTER'][0]['HOST'].first['NAME']
    assert data['CLUSTER'][0]['HOST'].first['NAME'].length > 0
  end
  test "get hosts" do
    g = Gmond.new(GMOND_HOST,GMOND_PORT)
    hosts = g.get_hosts
    assert_not_nil hosts
    assert_kind_of Array, hosts
    assert hosts.length > 0
    assert hosts.first.kind_of?(String)
  end
end
