
module PureRubyMarshal
  class WriteBuffer

  def initialize
    @ocache, @scache = {}, {}
  end

  def dump(object)
    str = b("\x04\b") << write(object)
  end

  private

  # Mruby does not support string encodings. For Rubies that do, we want an ASCII 8-BIT string.
  def b(str)
    str.respond_to?(:b) ? str.b : str
  end

  def str(s); s=s.to_s; fixnum(s.length)<<s; end
  def symbol(s); cache(";", s.to_sym, @scache) { ':' << str(s) }; end
  def hash(h)
    str = fixnum(h.length)
    h.each { |k,v| str << write(k) << write(v) }
    str
  end

  def basic(ob)
    return 'f'+str("0") if ob.class == Float && ob == 0.0
    case ob
      when  nil     then '0'
      when  true    then 'T'
      when  false   then 'F'
      when  0       then "i\0"
      when -0.0     then 'f'+str("-0")
# Disabling due to Mruby
#      when  Regexp  then '/'+str(ob.source)+fixnum(ob.options)
      when  Integer
        if ob >= 2**30 || ob < -2**30
          'l'+bignum(ob)
        else
          'i'+fixnum(ob)
        end
      when  String  then '"'+str(ob)
      when  Symbol  then symbol(ob)
      when  Float::INFINITY then 'f'+str("inf")
      when -Float::INFINITY then 'f'+str("-inf")
      when  Float   then 'f'+str(ob.nan? ? "nan" : ob)
      else nil
    end
  end

  def userclass(cur, klass)
    cur.class != klass ? ('C' << symbol(cur.class.name)) : ''
  end
  
  def write(cur)
    v = basic(cur)
    return v if v
    cache("@", cur.object_id, @ocache) do
      case cur
      when Class  then 'c' << str(cur.name)
      when Module then 'm' << str(cur.name)
      when Struct then 'S' << symbol(cur.class.name) << hash(cur.to_h)
      when Hash
        if cur.default
          userclass(cur, Hash) << '}' << hash(cur) << write(cur.default)
        else
          userclass(cur, Hash) << '{' << hash(cur)
        end
      when Array
        userclass(cur, Array) << '[' << fixnum(cur.length) <<
        cur.map { |a| write(a) }.join("")
      else
        if cur.respond_to?(:_dump)
          'u' << symbol(cur.class.name) << str(cur._dump(-1))
        elsif cur.respond_to?(:marshal_dump)
          'U' << symbol(cur.class.name) << write(cur.marshal_dump)
        else
          'o' << symbol(cur.class.name) << hash(
            cur.instance_variables.map {|ivar|
              [ivar, cur.instance_variable_get(ivar)]
            }
          )
        end
      end
    end
  end

  def fixnum(n)
    case n
    when 0        then "\0"
    when 1...123  then (n + 5).chr
    when -123..-1 then (256 + n - 5).chr
    else
      result = ""
      while n != 0 && n != -1
        result << (n & 255).chr
        n >>= 8
      end

      l_byte = n < 0 ? 256 - result.length : result.length
      l_byte.chr + result
    end
  end

  def bignum(n)
    sign = n >= 0 ? "+" : "-"
    n = n.abs
    bytes = ""
    while n > 0
      bytes << (n&0xff).chr
      n>>=8
    end
    len = (bytes.length+1)/2
    bytes << "\0" if bytes.length < len*2
    sign+fixnum(len)+bytes
  end

  def cache(type, key, cc)
    if ol = cc[key]
      return type+fixnum(ol)
    end
    cc[key] = cc.count
    yield
  end
end
end
