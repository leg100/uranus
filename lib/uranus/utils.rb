module Uranus::Utils
  def self.to_klass(resource)
    mods = resource.to_s.split('_').map{|mod|
      mod.capitalize!
      mod.upcase! if mod =~ /\d+$/
      mod
    }
    Object.const_get(['Uranus', 'Aws', mods].flatten.join('::'))
  end
end
