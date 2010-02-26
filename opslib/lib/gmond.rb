require 'socket'
require 'rubygems'
require 'xmlsimple'
class Gmond
   def initialize(server,port)
     @server = server
     @port = port
   end 
   def get_data
     t = TCPSocket.new(@server,@port)
     xml = t.gets(nil)
     t.close
     XmlSimple.xml_in(xml) 
   end
   def get_hosts
     get_data['CLUSTER'][0]['HOST'].collect{|h| h['NAME'] }
   end
end