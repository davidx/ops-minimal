
module GMetrics

  def gmetric(options={})
    options["type"] = "uint32" if ( !options.key?("type") and !options.key?(:type) )
    command = "gmetric"
    options.each{|k,v|
      command << ' --' + k.to_s + '="' + v.to_s + '"'
    }
    print command + "\n" if ENV.key?('GMETRICS_DEBUG')
    print `#{command}`
  end

end
include GMetrics
