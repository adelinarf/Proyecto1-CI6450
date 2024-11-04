class_name CustomTree
var key
var left 
var right
var height

func _init(key) -> void:
	self.key = key
	self.left = null
	self.right = null
	self.height = 1

func height_(N):
	if N == null:
		return 0
	return N.height
	
func right_rotate(y):
	var x = y.left
	var T2 = x.right

	# Perform rotation
	x.right = y
	y.left = T2

	# Update heights
	y.height = max(height_(y.left),height_(y.right)) + 1
	x.height = max(height_(x.left), height_(x.right)) + 1

	# Return new root
	return x

func left_rotate(x):
	var y = x.right
	var T2 = y.left

	# Perform rotation
	y.left = x
	x.right = T2

	# Update heights
	x.height = max(height_(x.left), height_(x.right)) + 1
	y.height = max(height_(y.left), height_(y.right)) + 1

	# Return new roo
	return y

func get_balance(N):
	if N == null:
		return 0
	return height_(N.left) - height_(N.right)

func insert(node, key):
	# 1. Perform the normal BST insertion
	if node == null:
		return CustomTree.new(key)

	if key < node.key:
		node.left = insert(node.left, key)
	elif key > node.key:
		node.right = insert(node.right, key)
	else:  # Duplicate keys not allowed
		return node

	# 2. Update height of this ancestor node
	node.height = max(height_(node.left), height_(node.right)) + 1

	# 3. Get the balance factor of this node
	# to check whether this node became 
	# unbalanced
	var balance = get_balance(node)

	# If this node becomes unbalanced, then
	# there are 4 cases

	# Left Left Case
	if balance > 1 and key < node.left.key:
		return right_rotate(node)

	# Right Right Case
	if balance < -1 and key > node.right.key:
		return left_rotate(node)

	# Left Right Case
	if balance > 1 and key > node.left.key:
		node.left = left_rotate(node.left)
		return right_rotate(node)

	# Right Left Case
	if balance < -1 and key < node.right.key:
		node.right = right_rotate(node.right)
		return left_rotate(node)
	return node

func min_value_node(node):
	var current = node

	# loop down to find the leftmost leaf
	while current.left != null:
		current = current.left

	return current

func delete_node(root, key):
	# STEP 1: PERFORM STANDARD BST DELETE
	if root == null:
		return root

	# If the key to be deleted is smaller 
	# than the root's key, then it lies in 
	# left subtree
	if key < root.key:
		root.left = delete_node(root.left, key)

	# If the key to be deleted is greater 
	# than the root's key, then it lies in 
	# right subtree
	elif key > root.key:
		root.right = delete_node(root.right, key)

	# if key is same as root's key, then 
	# this is the node to be deleted
	else:
		# node with only one child or no child
		if root.left == null or root.right == null:
			var temp = root.left if root.left else root.right

			# No child case
			if temp == null:
				root = null
			else:  # One child case
				root = temp

		else:
			# node with two children: Get the 
			# inorder successor (smallest in 
			# the right subtree)
			var temp = min_value_node(root.right)

			# Copy the inorder successor's 
			# data to this node
			root.key = temp.key

			# Delete the inorder successor
			root.right = delete_node(root.right, temp.key)

	# If the tree had only one node then return
	if root == null:
		return root

	# STEP 2: UPDATE HEIGHT OF THE CURRENT NODE
	root.height = max(height_(root.left),height_(root.right)) + 1

	# STEP 3: GET THE BALANCE FACTOR OF THIS 
	# NODE (to check whether this node 
	# became unbalanced)
	var balance = get_balance(root)

	# If this node becomes unbalanced, then 
	# there are 4 cases

	# Left Left Case
	if balance > 1 and get_balance(root.left) >= 0:
		return right_rotate(root)

	# Left Right Case
	if balance > 1 and get_balance(root.left) < 0:
		root.left = left_rotate(root.left)
		return right_rotate(root)

	# Right Right Case
	if balance < -1 and get_balance(root.right) <= 0:
		return left_rotate(root)

	# Right Left Case
	if balance < -1 and get_balance(root.right) > 0:
		root.right = right_rotate(root.right)
		return left_rotate(root)
	return root

func leftmost(root):
	if root.left != null:
		leftmost(root.left)
	return root.key



func rightside(root,key):
	if root != null:
		if root.key == key:
			return root.right
		else:
			rightside(root.left,key)
			rightside(root.right,key)

func pre_order(root):
	if root != null:
		#print("{0} ".format(root.key), end="")
		pre_order(root.left)
		pre_order(root.right)
