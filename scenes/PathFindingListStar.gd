class_name PathFindingListStar


#vAlgunas estructuras que se pueden usar para implementar PathfindingList son:
#Priority queues.
#Priority heaps.
#Bucketed priority queues


var list : Array
func _init(new : Array) -> void:
	self.list = new

# returns the NodeRecord structure in the list with the lowest costSoFar value.
func smallestElement() -> NodeRecord:
	var selected : NodeRecord
	var min = 10000000000
	for n in list:
		if n.estimatedTotalCost <= min:
			min = n.estimatedTotalCost 
			selected = n
	#print(selected,"seleccionado")
	return selected

func delete(node: NodeRecord) -> void:
	var found = 0
	for x in range(0,self.list.size()-1):
		if self.list[x].node==node:
			found=x
			break
	self.list.remove_at(found)

func add(node: NodeRecord) -> void:
	self.list.append(node)
	
# returns true only if the list contains a NodeRecord structure 
# whose node member is equal to the given parameter.
func contains(node: NodeR) -> bool:
	for n in list:
		if n.node == node:
			return true
	return false

# returns the NodeRecord structure from the list whose node member
# is equal to the given parameter.
func find(node: NodeR) -> NodeRecord:
	for n in list:
		if n.node == node:
			return n
	return NodeRecord.new()
	
func size() -> float:
	return self.list.size()
