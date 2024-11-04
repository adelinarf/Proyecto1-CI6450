extends Node2D

func mapping(f : Array) -> Array:
	var a =[]
	for j in f:
		a.append(j.fromNode.name+" to "+j.toNode.name)
	return a
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var g = Graph.new()
	g.createNodes()
	print(g.nodes)
	g.createConnections()
	print(g.connections)
	var heur = Heuristic.new(g.nodes[3])
	var f = pathfindAStar(g,g.nodes[0],g.nodes[3],heur)
	print(f)
	print(mapping(f))
#De esta forma podemos hacer la llamada a A* como
#pathfindAStar(graph, start, end, new Heuristic(end))

func pathfindAStar(graph: Graph, start: NodeR, end: NodeR, heuristic: Heuristic) -> Array:
	# This structure is used to keep track of the 
	# information we need for each node.
	# Initialize the record for the start node.
	var startRecord = NodeRecord.new()
	startRecord.node = start
	startRecord.connection = null
	startRecord.costSoFar = 0
	startRecord.estimatedTotalCost = heuristic.estimate(start)

	# Initialize the open and closed lists.
	var open = PathFindingListStar.new([startRecord])
	var closed = PathFindingListStar.new([])
	var current : NodeRecord
	var goal = end
	# Iterate through processing each node.
	while open.size() > 0:
	# Find the smallest element in the open list (using 
	# the estimatedTotalCost).
		current = open.smallestElement()

		# If it is the goal node, then terminate.
		if current.node == goal:
			break

	# Otherwise get its outgoing connections.
		var connections = graph.getConnections(current)

		# Loop through each connection in turn.
		for connection in connections:
			# Get the cost estimate for the end node.
			var endNode = connection.getToNode()
			var endNodeCost = current.costSoFar + connection.getCost()

			# If the node is closed we may have to skip, or 
			# remove it from the closed list.
			if closed.contains(endNode):
			# Here we find the record in the closed list 
			# corresponding to the endNode.
				var endNodeRecord = closed.find(endNode)

				# If we didn’t find a shorter route, skip.
				if endNodeRecord.costSoFar <= endNodeCost:
					continue
				# Otherwise remove it from the closed list.
				closed -= endNodeRecord
			# We can use the node’s old cost values to 
			# calculate its heuristic without calling the 
			# possibly expensive heuristic function.
				var endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Skip if the node is open and we’ve not 
	  # found a better route.
			elif open.contains(endNode):
		# Here we find the record in the open list 
		# corresponding to the endNode.
				var endNodeRecord = open.find(endNode)
		# If our route is no better, then skip.
				if endNodeRecord.costSoFar <= endNodeCost:
					continue
		# Again, we can calculate its heuristic.
				var endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar

	  # Otherwise we know we’ve got an unvisited 
	  # node, so make a record for it.
			else:
				var endNodeRecord = NodeRecord.new()
				endNodeRecord.node = endNode

				# We’ll need to calculate the heuristic 
				# value using the function, since we don’t 
				# have an existing record to use.
				var endNodeHeuristic = heuristic.estimate(endNode)

				# We’re here if we need to update the node. Update the 
				# cost, estimate and connection.
				endNodeRecord.cost = endNodeCost
				endNodeRecord.connection = connection
				endNodeRecord.estimatedTotalCost = endNodeCost + endNodeHeuristic

				# And add it to the open list.
				if not open.contains(endNode):
					open.add(endNodeRecord)

		# We’ve finished looking at the connections for the 
		# current node, so add it to the closed list and remove 
		# it from the open list.
		open.delete(current)
		closed.add(current)

	# We’re here if we’ve either found the goal, or if we’ve no 
	# more nodes to search, find which.
	if current.node != goal:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		return []
	
	# Compile the list of connections in the path.
	var path = []

	# Work back along the path, accumulating 
	# connections.
	while current.node != start:
			path.append(current.connection)
			var fromN = current.connection.getFromNode()
			current = graph.getToConnections(fromN, current.connection.cost)

	# Reverse the path, and return it.
	return path






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
