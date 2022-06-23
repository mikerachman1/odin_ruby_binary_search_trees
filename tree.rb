require_relative 'node.rb'

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
  
    def height(node = root)
      if node.nil?
        -1
      else
        node = find(node) if node.is_a?(Integer)
        left = height(node.left)
        right = height(node.right)
        if left > right
          1 + left
        else
          1 + right
        end
  
      end
    end
  
    def depth(node = root)
      output = 0
      node = find(node) if node.is_a?(Integer)
      current = @root
  
      until current.value == node.value
        if node.value < current.value
          current = current.left
        else
          current = current.right
        end
        output += 1
      end
      output
    end
  
    def balanced?(node = root)
      return true if node.nil?
      left = height(node.left)
      right = height(node.right)
  
      return true if (left - right).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  
      false
    end
  
    def rebalance(node = root)
      inorder = inorder(node) 
      Tree.new(inorder)
    end
  
  end