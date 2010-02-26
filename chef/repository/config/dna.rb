require 'rubygems'
require 'json'
require 'yaml'
require 'rubygems'
require 'xmlsimple'

$:<< File.dirname(__FILE__) + '/../lib'

HOSTS = {

        'x0' => {
                :recipes => [
                            :simpletest,
                            ],
                },

        }



hostname = `hostname -s`.strip

p "hostname : " + hostname
# replace this with ohai lib call

unless HOSTS.key?(hostname)
  p "Host #{hostname} not configured in! exiting!"
  exit 1
end

unless HOSTS[hostname].key?(:recipes)
  p "Host #{hostname} has no recipes configured! exiting!"
  exit 1
end


recipes = ENV.key?('RECIPES') ? ENV['RECIPES'].split(/,/) : HOSTS[hostname][:recipes]

p "host: #{hostname}"
p "recipes: #{recipes}"

config = {

        :recipes => recipes,

}

open(File.dirname(__FILE__) + "/dna.json", "w").write(config.to_json)

