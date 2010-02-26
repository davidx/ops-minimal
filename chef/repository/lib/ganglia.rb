require 'socket'
require 'rubygems'
require 'xmlsimple'
module Ganglia
  PORT=8649
  SERVER='localhost'
  
  def self.get_gmond_xml(server,port)
    begin
    t = TCPSocket.new(server,port)
     data = t.gets(nil)
     t.close
    rescue Errno::ECONNREFUSED
      p "error connection refused to ganglia"
      exit 0
    end
    data
  end
  def self.parse_gmond_xml(xml)
    XmlSimple.xml_in(xml)
  end
  def self.get_gmond_data(server,port)
    parse_gmond_xml(get_gmond_xml(server,port))
  end
  def self.get_hosts_for_metric(metric)

  end
  def hosts_with_metric(metric_name,server=SERVER,port=PORT)
    gmond_data = get_gmond_data(server,port)
    hosts = gmond_data['CLUSTER'][0]['HOST'] || []
    hosts.collect{|h|
      metrics = h['METRIC'] || []
      metrics.collect{|m| m['NAME'] == metric_name ? h['NAME'] : next }.uniq
    }.flatten.compact
  end
  def metrics_for_host(host,server=SERVER,port=PORT)
    raise StandardError("not yet implemented")    
    gmond_data = get_gmond_data(server,port)
    hosts = gmond_data['CLUSTER'][0]['HOST'] || []
    host = hosts.collect{|h| (h['NAME'] == host) ? h : next }.uniq.flatten
  end
  def metrics_with_string(metric_name,server=SERVER,port=PORT)
    gmond_data = get_gmond_data(server,port)
    hosts = gmond_data['CLUSTER'][0]['HOST']
    data = {}
    hosts.collect{|h|

      metrics = h['METRIC'] || []
      metrics = metrics.collect{|m| m['NAME'] if m['NAME'] =~ /#{metric_name}/ }.flatten.compact.uniq
      data[ h['NAME'] ] = metrics
    }.flatten.compact
    data
  end
end
include Ganglia