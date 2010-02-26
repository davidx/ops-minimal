#!/usr/bin/ruby

$:<< File.dirname(__FILE__)

require 'rubygems'
require 'choice'
require 'nagios'
require 'net/dns/resolver'
require 'timeout'

Choice.options do
  header ''
  header 'Specific options:'

  option :host, :required => true do
    short '-H'
    long '--host=HOST'
    desc 'The hostname or djb of the host to check (required)'
  end
  option :query, :required => true do
    short '-q'
    long '--query=QUERY'
    desc 'The dns query, name to be resolved. (required)'
  end
  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

HOSTNAME=Choice.choices[:host]
QUERY=Choice.choices[:query]

begin
    timeout(1) do
      start_time = Time.now
      packet = Net::DNS::Resolver.start(QUERY)
      duration = Time.now - start_time

      exit_critical("no answer record") unless packet.answer.any?
      exit_ok("response for #{QUERY} @ #{HOSTNAME} returned in #{duration} seconds")      

    end
rescue
    exit_critical("error: #{$!}")
end