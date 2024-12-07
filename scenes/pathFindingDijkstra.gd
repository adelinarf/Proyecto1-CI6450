func pathfindDijkstra(graph: Graph,start: NodeR,end: NodeR) -> Connection:#[]
	var startRecord = NodeRecord.new()
	startRecord.node = start
	startRecord.connection = null
	startRecord.costSoFar = 0

	# Initialize the open and closed lists.
	var open =  PathFindingList.new([startRecord])
	#open += startRecord
	var closed = PathFindingList.new([])
	var goal :NodeR
	var path = []
  # Iterate through processing each node
	while open.length() > 0:
	# Find the smallest element in the open list.
		var current: NodeRecord = open.smallestElement()
  
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
			# Skip if the node is closed.
			if closed.contains(endNode):
				continue
			# .. or if it is open and we’ve found a worse 
			# route.
			elif open.contains(endNode):
			# Here we find the record in the open list
			# corresponding to the endNode.
				var endNodeRecord = open.find(endNode)
				if endNodeRecord.cost <= endNodeCost:
					continue
		  # Otherwise we know we’ve got an unvisited node, 
		  # so make a record for it.
			else:
				var endNodeRecord = NodeRecord.new()
				endNodeRecord.node = endNode
				# We’re here if we need to update the node. 
				# Update the cost and connection.
				endNodeRecord.cost = endNodeCost
				endNodeRecord.connection = connection
	
				# And add it to the open list.
				if not open.contains(endNode):
					open += endNodeRecord
		
		# We’ve finished looking at the connections for the 
		# current node, so add it to the closed list and 
		# remove it from the open list.
		open -= current
		closed += current

		# We’re here if we’ve either found the goal, or if we’ve
		# no more nodes to search, find which.
		if current.node != goal:
		# We’ve run out of nodes without finding the goal, so 
		# there’s no solution.
			return null

		# Compile the list of connections in the path.
		

		# Work back along the path, accumulating connections.
		while current.node != start:
			path += current.connection
			#current = current.connection.getFromNode()
  # Reverse the path, and return it.
	return path #reverse
