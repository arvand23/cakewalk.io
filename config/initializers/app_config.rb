require 'active_support/core_ext/hash'

def symbolize_keys!(thing)
  case thing
  when Array
    thing.each{|v| symbolize_keys!(v)}
  when Hash
    thing.symbolize_keys!
    thing.values.each{|v| symbolize_keys!(v)}
  end
  thing
end

def symbolize_keys(thing)
  case thing
  when Array
    thing.map{|v| symbolize_keys(v)}
  when Hash
    inj = thing.inject({}) {|h, (k,v)| h[k] = symbolize_keys(v); h}
    inj.symbolize_keys
  else
    thing
  end
end

APP_CONFIG = symbolize_keys(YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env])

#appconfig used to be in application.rb, but this way it loads it based on env.... everywhere where i use the keys, made them :fdslfkjdsf (into symbols)