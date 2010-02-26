

class GemEnvironment
  attr_reader :prefix
  def self.load(prefix)
    new(:prefix => prefix)
  end
  def list
    list = []
    gem_command("list").split(/\n/).collect do|line|
      list.push(parse_line(line))
    end
    list
  end
  def gem_command(args)
    `#{@prefix}/bin/gem #{args}`
  end
  def initialize(options)
     @prefix = options[:prefix]  
   end

  def parse_line(line)
    elements = line.gsub(/(\(|\)|\,)/, '').split(/\s+/)
    name = elements.shift
    versions = elements
    {:name => name, :versions => versions}
  end

  def query(name, options = {})
    query = gem_command("query -n #{name}")
    query.strip.length > 0 ? parse_line(query) : nil
  end

  def is_installed?(name, options={})  
    result = query(name)    

    return false unless result
    unless options[:version]
      return is_installed_name?(name,options)
    end
    return false unless query(name)[:versions].include?(options[:version])
    return false unless query(name)[:name] == name
    return true
  end
  def is_installed_name?(name,options={})
    result = query(name)
    return false unless result
    return false unless result.key?(:name)
    return true if result[:name] == name  
  end
  #def load_gem_environment(gem_prefix)
  #  GemEnv.new(:prefix => gem_prefix)
  #end

end