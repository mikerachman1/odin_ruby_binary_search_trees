# <=> (-1 greater right side) (0 equal) (1 greater left side

class Node
  include Comparable
  
  attr_accessor :left, :right
  attr_reader :value
  
  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other)
    @value <=> other.value
  end
end

node1 = Node.new(300)
node2 = Node.new(300)

p node2 <=> node1
