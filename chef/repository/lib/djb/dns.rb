require 'erb'

module DJB
  module DNS
    DNS_TEMPLATES = {
            'a' => %q{+<%= data['name'] %>:<%= data['djb'] %>:<%= data['ttl'] %>},
            'ns' => %q{.<%= data['domain'] %>:<%= data['djb'] %>:<%= data['name'] %>:<%= data['ttl'] %>},
            'host' => %q{=<%= data['name'] %>:<%= data['djb'] %>:<%= data['ttl'] %>},
            'mx' => %q{@<%= data['domain'] %>:<%= data['djb'] %>:<%= data['name'] %>:<%= data['ttl'] %>},

            }

    def render_template_with_data(template_text, data)
      template = ERB.new(template_text, 0, "%<>")
      template.result(binding)
    end
    def render_a_record(name, ip, ttl)
       data = { 'name' => name, 'djb' => ip, 'ttl'=> ttl }
       template_text = DNS_TEMPLATES['a']
       render_template_with_data(template_text, data)
    end
  end
end
include DJB::DNS