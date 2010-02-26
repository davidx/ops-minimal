#!/usr/bin/ruby

# this is a generic nagios check to be used on a gmetad server


$:<< File.dirname(__FILE__)
require 'rubygems'
require 'choice'
require 'nagios'

Choice.options do
  header ''
  header 'Specific options:'

  option :host, :required => true do
    short '-H'
    long '--host=HOST'
    desc 'The hostname or djb of the host to check (required)'
  end

  option :metric, :required => true do
    short '-m'
    long '--metric=METRIC'
    desc 'The metric name to check (required)'
  end
  option :threshold, :required => true do
    short '-t'
    long '--threshold=THRESHOLD'
    desc 'The threshold to apply (required)'
  end
  option :operator do
    short '-o'
    long '--operator=OPERATOR'
    desc 'The operator to apply to the threshold (default >)'
    default '>'
  end
  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

CLUSTER='prod'
HOSTNAME=Choice.choices[:host]
METRIC=Choice.choices[:metric]
THRESHOLD=Choice.choices[:threshold].to_i
STALE_TIMEOUT = 900
BASE_RRD_PATH = '/var/lib/ganglia/rrds'
FULL_RRD_PATH = File.join(BASE_RRD_PATH, CLUSTER, HOSTNAME, METRIC) + ".rrd"
OPERATOR=Choice.choices[:operator]

def rrdtool(cmd, file)
  command = "rrdtool #{cmd.to_s} #{file}|grep ':' "
  `#{command}`.strip
end
def get_last_update(rrd_file)
  out = rrdtool(:lastupdate, rrd_file)
  time, value = out.gsub(/\s+/, '').split(/:/)
  [time, value.to_i]
end

def exit_generic(status, message)
  print "HOST: " + HOSTNAME + " METRIC: " + METRIC + " [" + status.to_s.upcase + "] " + message + "\n"
  exit NAGIOSMAP[status.to_s]
end

def is_stale?(time)
  DateTime.now.strftime("%s").to_i - time.to_i > STALE_TIMEOUT
end

unless File.exists?(FULL_RRD_PATH)
  exit_critical("no such rrd file : " + FULL_RRD_PATH)
end

time,value = get_last_update(FULL_RRD_PATH)

if is_stale?(time)
  exit_critical("stale data")
end

if value.send(OPERATOR, THRESHOLD)

  exit_critical("value #{value} passed (#{OPERATOR}) threshold #{THRESHOLD}!")
else
  exit_ok("value #{value} not passed (#{OPERATOR}) threshold #{THRESHOLD}")
end
