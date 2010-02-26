# test rendering dns config in chef.

$:<< File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'rubygems'
require 'dust'
require 'erb'
require 'djb/dns'

include DJB::DNS

TEST_DATA = {
        'a' => { 'name' => 'testhost.example.com',
                'djb' => '10.0.3.232',
                'ttl' => '86400',

                },

        'mx' => { 'domain' => 'example.com',
                'name' => 'smtp.example.com',
                'djb' => '10.10.10.33',
                'distance' => '10',
                'ttl' => 86400
        },
        'ns' => { 'domain' => 'example.com',
                'name' => 'ns.example.com',
                'djb' => '10.10.10.33',
                'ttl' => 86400
        },

        'host' => { 'name' => 'testhost.example.com',
                'djb' => '10.0.3.232',
                'ttl' => '86400'
        },
        }

unit_tests do
  test "render a record" do
    name = TEST_DATA['a']['name']
    ip = TEST_DATA['a']['djb']
    ttl = TEST_DATA['a']['ttl']

    text = render_a_record(name, ip, ttl)
    assert_not_nil text
    assert_kind_of String, text
    assert_equal "+#{name}:#{ip}:#{ttl}", text
  end
  test "render a record with erb" do
    template =  DNS_TEMPLATES['a']
    data = TEST_DATA['a']

    template_text = DNS_TEMPLATES['a']
    template = ERB.new(template_text, 0, "%<>")
    template.result(binding)

  end
  test "render template with data" do
    template =  DNS_TEMPLATES['a']
    data = TEST_DATA['a']

    rendered_template = render_template_with_data(template, data)
    assert_not_nil rendered_template
    assert_kind_of String, rendered_template
    assert_equal "+testhost.example.com:10.0.3.232:86400", rendered_template
  end
  test "render ns record" do
    template =  DNS_TEMPLATES['ns']
    data = TEST_DATA['ns']

    rendered_template = render_template_with_data(template, data)
    assert_not_nil rendered_template
    assert_kind_of String, rendered_template
    assert_equal ".#{data['domain']}:#{data['djb']}:#{data['name']}:#{data['ttl']}", rendered_template
    assert_equal ".example.com:10.10.10.33:ns.example.com:86400", rendered_template
  end
  test "render host record" do
    template =  DNS_TEMPLATES['host']
    data = TEST_DATA['host']

    rendered_template = render_template_with_data(template, data)
    assert_not_nil rendered_template
    assert_kind_of String, rendered_template
    assert_equal "=#{data['name']}:#{data['djb']}:#{data['ttl']}", rendered_template
    assert_equal "=testhost.example.com:10.0.3.232:86400", rendered_template
  end
  test "render mx record" do
    template =  DNS_TEMPLATES['mx']
    data = TEST_DATA['mx']
    rendered_template = render_template_with_data(template, data)
    assert_not_nil rendered_template
    assert_kind_of String, rendered_template
    assert_equal "@#{data['domain']}:#{data['djb']}:#{data['name']}:#{data['ttl']}", rendered_template
    assert_equal "@example.com:10.10.10.33:smtp.example.com:86400", rendered_template
  end
end




