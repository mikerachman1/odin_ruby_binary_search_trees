# <=> (-1 greater right side) (0 equal) (1 greater left side)

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

class Tree
  attr_reader :array, :root
  
  def initialize(array)
    @array = array.sort.uniq
    @root = self.build_tree
  end

  def build_tree(array = @array)
    #return root node at end
    return nil if array.empty?
    
    mid = (array.size - 1) / 2
    root_node = Node.new(array[mid])

    root_node.left = build_tree(array[0...mid])
    root_node.right = build_tree(array[(mid + 1)..-1])

    root_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test_array = [1, 2, 3, 4, 5, 6, 7, 8, 9]

tree = Tree.new(test_array)
p tree.array

tree.build_tree
tree.pretty_print
