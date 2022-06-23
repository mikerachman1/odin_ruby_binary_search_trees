class Node
    include Comparable
    
    attr_accessor :left, :right, :value
    
    def initialize(value = nil, left = nil, right = nil)
      @value = value
      @left = left
      @right = right
    end
  
    def <=>(other)
      @value <=> other.value
    end
  end