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

  def insert(value)
    node = Node.new(value)
    current = @root
    loop do
      if value < current.value
        if current.left.nil?
          current.left = node
          break
        end
        current = current.left
      elsif value > current.value
        if current.right.nil?
            current.right = node
            break
          end
        current = current.right
      elsif value == current.value
        puts "no duplicate entries allowed"
        break
      end
    end
    node
  end
end

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(test_array)
p tree.array

tree.insert(1008)
tree.pretty_print
