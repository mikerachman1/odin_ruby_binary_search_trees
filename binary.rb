# <=> (-1 greater right side) (0 equal) (1 greater left side)

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

  def insert(value, node = @root)
    return nil if value == node.value
    if value < node.value
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?

    node
  end

  def delete(value, node = @root)
    return node if node.nil?
    
    if value < node.value
      node.left = delete(value, node.left)
    elsif value > node.value
      node.right = delete(value, node.right)
    else #if node equals argument
      #no or one child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      #2 children
      leftmost_node = leftmost_leaf(node.right)
      node.value = leftmost_node.value
      node.right = delete(leftmost_node.value, node.right)
    end
    node
  end

  def find(value, node = root)
    return "#{value} not included in tree" unless @array.include?(value)
    return node if value == node.value

    if value < node.value
      node = find(value, node.left)
    else
      node = find(value, node.right)
    end
    node
  end

  def level_order_iterative
    queue = [@root]
    result = []

    until queue.empty? do
      node = queue.shift
      block_given? ? yield(node) : result << node.value
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
    result unless block_given?
  end

  def level_order_recursive(node = @root, queue = [], result = [])
    block_given? ? yield(node) : result << node.value unless node.nil?

    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?

    return if queue.empty?

    level_order_recursive(queue.shift, queue, result)
    result unless block_given?
  end

  def preorder(node = @root, result = [], &block)
    return if node.nil?
    yield(node) if block_given? 
    result << node.value
    
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)
    result
  end

  def inorder(node = @root, result = [], &block)
    return if node.nil?
    inorder(node.left, result, &block)
    yield(node) if block_given?
    result << node.value
    inorder(node.right, result, &block)
    result
  end

  def postorder(node = @root, result = [], &block)
    return if node.nil?
    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    yield(node) if block_given?
    result << node.value
    result
  end
end

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(test_array)
p tree.array


tree.pretty_print
p tree.postorder #{ |node| print "#{node.value}, "}