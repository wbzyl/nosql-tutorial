require 'oj'
require 'mongo'

class String
  def to_json
    Oj.load(self)
  end
end

a = IO.readlines('data/zips.json').shift(4)

# IO.readlines('data/zips.json').each_slice(3000) do |a|
#   puts a.size
# end

h = a.map(&:to_json)

puts h.inspect

def to_j(s)
  Oj.load(s)
end

h = a.map(&method(:to_j))

puts h.inspect
