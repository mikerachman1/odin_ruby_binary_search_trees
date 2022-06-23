require_relative 'node.rb'
require_relative 'tree.rb'

tree = Tree.new(Array.new(15) { rand(1...100)})

# p tree.balanced?
# p tree.level_order_iterative
# p tree.preorder
# p tree.postorder
# p tree.inorder

5.times do
    tree.insert(rand(1...100))
end

p tree.balanced?
tree = tree.rebalance
p tree.balanced?
p tree.level_order_iterative
p tree.preorder
p tree.postorder
p tree.inorder