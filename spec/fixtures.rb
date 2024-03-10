Point = Struct.new(:x, :y)

class Point2
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    other.is_a?(Point2) &&
      other.x == self.x &&
      other.y == self.y
  end

  def inspect = "<Point2 x=#{x} y=#{y}>"
end

class UserArray < Array
end

class UserHash < Hash
end

class UserString < Hash
end

module MyModule
end

# Loop
b = {foo: :bar}
a = {hash: 42}
a[:b] = b
b[:a] = a

pt = Point.new(3,7)

ua = UserArray[1,2,3]

class WithDump
  attr_accessor :var
  
  def initialize var
    @var = var
  end

  def _dump(level)
    @var.b
  end

  def self._load(var)
    WithDump.new(var)
  end

  def inspect = "<WithDump #{@var.inspect}>"
end


class WithMarshalDump
  attr_accessor :var

  def initialize var
    @var = var
  end

  def marshal_dump
    @var.b.dup
  end

  def marshal_load(data)
    @var = data.dup
  end

  def inspect = "<WithMarshalDump #{@var.inspect}>"
end

hash_default = Hash.new(:default)
hash_default[:key] = :actual

FIXTURES = {
  'nil' => nil,
  'true' => true,
  'false' => false,
  'zero' => 0,
  'small positive number' => 10,
  'small negative number' => -10,
  'big positive number' => 99999,
  'big negative number' => -99999,
  'symbol' => :a_symbol,
  'ASCII 8-bit string' => 'a string'.b,
# FIXME: No encoding support in Mruby
#  But also missing encoding support in this class
#  'UTF-8 string' => 'a string'.force_encoding('UTF-8'),
  'empty array' => [],
  'non-empty array' => [1,2,3],
  'empty hash' => {},
  'non-empty hash' => { 15 => 5 },
  'hash with default' => hash_default,
  'float' => 1.5,
  'class' => Array,
  'module' => Marshal,
  'struct' => Point.new(3, 7),
# FIXME: No Regexp support in Mruby; but also requires encoding support
#  'regexp' => /a_regexp/,
  'abstract object with ivars' => Point2.new(5, 10),
  'user class (Array)' => UserArray[1,2,3],
  'user class (Hash)' => UserHash[a: 42],
  'user class (String)' => UserString.new("test".b),
  'symbol link' => [:symbol1, :symbol1],
  'object link (module)' => [Marshal, Marshal],
  'object link (class)' => [Object, Object],
  'object link (struct)' => [pt, pt],
  'object link (user class)' => [ua,ua],
  'loop' => a,
  '0.0' => 0.0,
  '0.1' => 0.1,
  '+Infinity' => Float::INFINITY,
  '-Infinity' => -Float::INFINITY,
  "Nan" => Float::NAN,
  "_dump and _load methods" => WithDump.new("varset"),
  "marshal_dump" => WithMarshalDump.new("marshaled var")
}

(1..128).each do |i|
  FIXTURES[2**i] = 2**i
  FIXTURES[-2**i] = -2**i
end

# Want to exceed the checks at -123/+123 and go above/below -256/256 at a minimum
(-300..300).each do |i|
  FIXTURES[i] = i
end
