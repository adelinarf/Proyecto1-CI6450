extends Node2D

var g
# Called when the node enters the scene tree for the first time.
func vertexes(c1):
	var left_upper = c1.position + Vector2(-c1.texture.get_width()/2,-c1.texture.get_height()/2)
	
	var left_down = c1.position + Vector2(-c1.texture.get_width()/2,c1.texture.get_height()/2)
	
	var right_upper = c1.position + Vector2(c1.texture.get_width()/2,-c1.texture.get_height()/2)
	
	var right_down = c1.position + Vector2(c1.texture.get_width()/2,c1.texture.get_height()/2)
	return [left_upper,left_down,right_upper,right_down]
	
func mapping(f : Array) -> Array:
	var a =[]
	for j in f:
		a.append(j.fromNode.name+" to "+j.toNode.name)
	return a

func _ready() -> void:
	g = Graph.new()
	var wall = get_node("Sprite2D")
	var v = vertexes(wall)
	
	g.generate_voronoi_diagram(500,500,10,$TextureRect,v)
	g.createNodes()
	print(g.nodes)
	g.createConnections()
	print(g.connections)
	var f = pathfindDijkstra(g,g.nodes[0],g.nodes[3])
	print(f,"THIS IS THE PATH")
	print(mapping(f))


func pathfindDijkstra(graph: Graph,start: NodeR,end: NodeR) -> Array:#[]
	var startRecord = NodeRecord.new()
	startRecord.node = start
	var connecction = Connection.new()
	connecction.fromNode = graph.nodes[0]
	connecction.toNode =  graph.nodes[1]
	connecction.cost = 10
	startRecord.connection = connecction
	startRecord.costSoFar = 0

	# Initialize the open and closed lists.
	var open =  PathFindingList.new([startRecord])
	#open += startRecord
	var closed = PathFindingList.new([])
	var goal :NodeR = end
	var path = []
	var current: NodeRecord
  # Iterate through processing each node
	while open.size() > 0:
	# Find the smallest element in the open list.
		current = open.smallestElement()
  
	# If it is the goal node, then terminate.
		if current.node == goal:
			break
  
		# Otherwise get its outgoing connections.
		var connections = graph.getConnections(current)
		print(connections,"connections")
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
					#open += 
					print("add")
					open.add(endNodeRecord)
		
		# We’ve finished looking at the connections for the 
		# current node, so add it to the closed list and 
		# remove it from the open list.
		open.delete(current) #-= current
		closed.add(current) #+= current
		#print(closed.list,"closed")
		#print(open.list,"open")

		# We’re here if we’ve either found the goal, or if we’ve
		# no more nodes to search, find which.
	if current.node != goal:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		#print("this")
		return []
	else:
	# Compile the list of connections in the path.
	# Work back along the path, accumulating connections.
		print("else")
		while current.node != start:
			print(current.connection.fromNode)
			print(current.connection.toNode)
			path.append(current.connection)
			#print("append path",path)
			print(current)
			print(current.node)
			print(current.node.name)
			#print(current.connection)
			var fromN = current.connection.getFromNode()
			#print(fromN)
			current = graph.getToConnections(fromN, current.connection.cost)
			#current = current.connection.getFromNode()
# Reverse the path, and return it.
		return path #reverse


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var f = pathfindDijkstra(g,g.nodes[0],g.nodes[3])
	#print(f,"THIS IS THE PATH P")
