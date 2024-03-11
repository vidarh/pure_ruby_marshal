
# Prelude for Mruby/DragonRuby version to polyfill Marshal
# A merged file is produced with 'rake stb' in the main directory.

module PureRubyMarshal
end

module Marshal
  def dump(ob)
    PureRubyMarshal.dump(ob)
  end

  def load(str)
    PureRubyMarshal.load(str)
  end
end
