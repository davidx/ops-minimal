# test gem helpers in chef.

$:<< File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'rubygems'
require 'dust'
require 'erb'
require 'gem_helper'

TESTDATA = { :a => 'dust (0.1.6)',
             :b => 'dust (0.1.6, 1.3, 2.5)'
           }
GEMPREFIX = '/usr'

unit_tests do  
  test "should load gem environment" do
    gem_prefix = '/usr'
    gem_env = GemEnvironment.load(gem_prefix)
    assert_not_nil gem_env
    assert_kind_of GemEnvironment, gem_env
    assert_equal GemEnvironment.load(gem_prefix).prefix, GemEnvironment.new(:prefix => gem_prefix).prefix
  end
  test "should return list of installed gems" do
    gem_env = GemEnvironment.load(GEMPREFIX)
    assert_not_nil gem_env
    assert_kind_of GemEnvironment, gem_env
    assert gem_env.respond_to?(:list)
    list = gem_env.list
    assert_not_nil list
    assert_kind_of Array, list
    assert list.length > 0
    assert list.first.kind_of?(Hash)
    assert list.first.key?(:name)
    assert list.first.key?(:versions)
  end

  test "should show if installed" do
    gem_env = GemEnvironment.load(GEMPREFIX)
    installed = gem_env.is_installed?('dust')
    assert_equal  true, installed
    notinstalled = gem_env.is_installed?('bogusgem')
    assert_equal  false, notinstalled
  end

  test "should show if installed exact version" do
    gem_env = GemEnvironment.load(GEMPREFIX)
    installed = gem_env.is_installed?('rake', :version => '0.8.3')
    assert_equal true, installed
    notinstalled = gem_env.is_installed?('dust', :version => '20.8.3')
    assert_equal  false, notinstalled 
  end
  test "should parse gemline with one version" do
    gem_env = GemEnvironment.load(GEMPREFIX)

     assert_nothing_raised do

       gem_env.parse_line(TESTDATA[:a])
     end
     parsed = gem_env.parse_line(TESTDATA[:a])
     assert_not_nil parsed
     assert_kind_of Hash, parsed
     assert parsed.key?(:name)
     assert parsed.key?(:versions)
     assert parsed[:versions].kind_of?(Array)
     assert parsed[:versions].length == 1
     assert_equal '0.1.6', parsed[:versions].first
   end
   test "should parse gemline with multiple versions" do
     gem_env = GemEnvironment.load(GEMPREFIX)

     parsed_multiple = gem_env.parse_line(TESTDATA[:b])
     assert_not_nil parsed_multiple
     assert_kind_of Hash, parsed_multiple
     assert parsed_multiple.key?(:name)
     assert parsed_multiple.key?(:versions)
     assert parsed_multiple[:versions].kind_of?(Array)
     assert parsed_multiple[:versions].length > 1, parsed_multiple[:versions].inspect
     assert_equal '0.1.6', parsed_multiple[:versions].first
     assert_equal '2.5', parsed_multiple[:versions].last
   end
   test "should query gem" do
     gem_env = GemEnvironment.load(GEMPREFIX)
      
     assert_nothing_raised do
       gem_env.query('dust')
      end
     result = gem_env.query('dust')
     assert_not_nil result
     assert_kind_of Hash, result
     assert result.key?(:name)
     assert result.key?(:versions)
     assert result[:versions].kind_of?(Array)
     assert result[:versions].length > 0, result[:versions].inspect
   end 
end




