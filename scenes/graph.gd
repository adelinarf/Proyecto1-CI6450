class_name Graph

# An array of connections outgoing from the given node.
var nodes = []
var connections = []

func getLastConnection(size:float) -> Connection:
	for c in connections:
		if c.toNode.name == str(size):
			return c
	return Connection.new()
			
			
	

func getToConnections(toNode:NodeR, cost : float) -> NodeRecord:
	for c in connections:
		if c.toNode.vector == toNode.vector or c.toNode.name == toNode.name:
			
			var a = NodeRecord.new()
			a.node = toNode
			a.connection = c
			a.costSoFar = cost-a.connection.cost
			a.cost = a.connection.cost
			return a
	if toNode.name == '0':
		for c in connections:
			if c.fromNode.name == '0':
				var a = NodeRecord.new()
				a.node = toNode
				a.connection = c
				a.costSoFar = cost-a.connection.cost
				a.cost = a.connection.cost
				return a		
	return NodeRecord.new()
		

func getConnections(fromNode : NodeRecord) -> Array: #connecgtion[]
	var a = []
	for connection in connections:
		if connection.fromNode == fromNode.node:
			a.append(connection)
	return a

func createNodes() -> void:
	nodes.append(NodeR.new(Vector2.ZERO))
	nodes.append(NodeR.new(Vector2.ZERO))
	nodes.append(NodeR.new(Vector2.ZERO))
	nodes.append(NodeR.new(Vector2.ZERO))

func createConnections() -> Array:
	var a = []
	for n in range(0,nodes.size()-1):
		var connection = Connection.new()
		connection.fromNode = nodes[n]
		connection.fromNode.name = str(n)
		connection.toNode = nodes[n+1]
		connection.toNode.name = str(n+1)
		connection.cost = 10
		a.append(connection)
	connections=a
	return a

var node_image_path = "res://sprites/background/red_crystal_0000.png"

func createNodesTiles() -> void:
	var num_tiles_per_row = 20
	var height = 2
	var width = 2
	var sprite = Sprite2D.new()
	sprite.texture = load(node_image_path)
	sprite.position = Vector2.UP

func createConnectionsTiles() -> Array:
	return []
	
func hypot(x,y):
	return sqrt(x**2 + y**2)

func inside(x,y,v):
	return point_in_polygon(Vector2(x,y),v)

func point_in_polygon(point, polygon):
	var num_vertices = polygon.size()
	var x =  point.x
	var y = point.y
	var inside = false
 
	# Store the first point in the polygon and initialize the second point
	var p1 = polygon[0]
 
	# Loop through each edge in the polygon
	for i in range(1, num_vertices + 1):
		# Get the next point in the polygon
		var p2 = polygon[i % num_vertices]
 
		# Check if the point is above the minimum y coordinate of the edge
		if y > min(p1.y, p2.y):
			# Check if the point is below the maximum y coordinate of the edge
			if y <= max(p1.y, p2.y):
				# Check if the point is to the left of the maximum x coordinate of the edge
				if x <= max(p1.x, p2.x):
					# Calculate the x-intersection of the line connecting the point to the edge
					var x_intersection = (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x
 
					# Check if the point is on the same line as the edge or to the left of the x-intersection
					if p1.x == p2.x or x <= x_intersection:
						# Flip the inside flag
						inside = not inside
 
		# Store the current point as the first point for the next iteration
		p1 = p2
 
	# Return the value of the inside fla
	return inside

func generate_voronoi_diagram(width, height, num_cells,text,vert):
	var dynImage = Image.create(500, 500, false, Image.FORMAT_RGBA8)
	var imgx = 500
	var imgy = 500
	var nx = []
	var ny = []
	var vny = []
	var nr = []
	var ng = []
	var nb = []
	var color = [Color.BLANCHED_ALMOND,Color.AQUAMARINE,Color.BLUE,Color.CADET_BLUE,
	Color.BLUE_VIOLET,Color.BROWN,Color.CHARTREUSE,Color.DARK_GREEN,Color.DARK_MAGENTA,
	Color.DARK_ORANGE,Color.DARK_TURQUOISE]
	for i in range(num_cells):
		nx.append(randi_range(0,imgx))
		ny.append(randi_range(0,imgy))
		nr.append(randi_range(0,256))
		ng.append(randi_range(0,256))
		nb.append(randi_range(0,256))
		
		
	var positions = []
	for x in num_cells:
		positions.append([])
	for y in range(imgy):
		for x in range(imgx):
			var dmin = hypot(imgx-1, imgy-1)
			var j = -1
			for i in range(num_cells):
				var d = hypot(nx[i]-x, ny[i]-y)
				if d < dmin:
					dmin = d
					j = i
			#node based on j
			#connection from j to j+1
			if not inside(x,y,vert):
				positions[j].append([x,y,color[j]])
				dynImage.set_pixel(x,y,color[j])
			#putpixel((x, y), (nr[j], ng[j], nb[j]))
	text.texture = ImageTexture.create_from_image(dynImage)
	
func createNodesVoronoi() -> void:
	pass

func createConnectionsVoronoi() -> Array:
	return []
	
func leftmost(T):
	#el elemento mas a la izquierda de T
	return T.leftmost(T)
	
func insertT(vertexes,p):
	# [left_upper,left_down,right_upper,right_down]
	#insertar en T los poligonos que intersectan a p
	var T = CustomTree.new(null)
	var root = null
	for vertex in vertexes:
		if vertex[0].x <= p.x and p.x <= vertex[2].x or vertex[1].y <= p.y and p.y <= vertex[3].y:
			root = T.insert(root,vertex)
	return root
	
var center
  
func sort_clockwise(a, b):
	return (a - center).angle() < (b - center).angle()
	
func orderVertices(p,vertexes):
	var c = []
	center = p
	for v in vertexes:
		for u in v:
			c.append(u)
	c.sort_custom(sort_clockwise)
	return c

func findSemirrecta(v,vertexes,p):
	for vertex in vertexes:
		for vx in vertex:
			if vx == p:
				return vertex
				
	

func visibleVertices(p,S,vertexes):
	var V = orderVertices(p,vertexes)
	var visibles = []
	var T 
	T = insertT(vertexes,p)
	var segmentVisible = leftmost(T)
	for v in V:
		if visible(p,v,segmentVisible,vertexes):
			visibles.append(v)
			var l = findSemirrecta(v,vertexes,p)
			#l semirrecta de origen en p y pasa por v
			#insertar en T los lados incidentes en v que se
			#var vertex = Vector2.ZERO
			var vertt = []
			for vertex in vertexes:
				if vertex[0].x <= v.x and v.x <= vertex[2].x or vertex[1].y <= v.y and v.y<= vertex[3].y:
					vertt.append(vertex)
					T = T.insert(T,vertex)
			
			#T = T.analyzeIncident(T,l,v,vertt)
			
			#eliminar en t los lados que se encuentran del lado
			var rightmost = T.rightside(T,l)
			if rightmost == null:
				pass
			else:
				T = T.delete_node(T, rightmost)
			
			#derecho de l
			segmentVisible = leftmost(T)
	return visibles
	
func intersect(p,v,S):
	if S[0] <= p.x <= S[2] or S[1] <= p.y <= S[3] or S[0] <= v.x <= S[2] or S[1] <= v.y <= S[3] :
			return true
	return false
	
func visible(p,v,segmentVisible,S):
	var polygon 
	for vertex in S:
		for vx in vertex:
			if vx == p:
				return vertex
	#si segmento p v intersecta el poligono donde p
	#return false
	if intersect(p,v,polygon):
		return false
	elif intersect(p,v,segmentVisible):
		return false
	else:
		return true
	

func visibilityGraph(S,vertexes):
	var G = []
	for obstacle in vertexes:
		for vertex in obstacle:
			var W = visibleVertices(vertex,S,vertexes)
			for w in W:
				G.append(w)
	print(G)

func getLines(S):
	var lines = []
	for v in S:
		if v.size()>2:
			lines.append(v[1]-v[0])
			lines.append(v[2]-v[1])
			lines.append(v[3]-v[2])
			lines.append(v[0]-v[3])
		elif v.size()>1:
			lines.append(v[0]-v[1])
			lines.append(v[1]-v[0])
		else:
			lines.append(v[0])
			
	return lines
			

func visibleF(p1,p2,S,node):
	var line1 = p2-p1
	var lines = S 
	
	var visible = true
	
	for line2 in lines:		
		if (line2[1] == p1 and line2[0] == p2) or (line2[0]==p1 and line2[1]==p2):
			continue
		if Geometry2D.segment_intersects_segment(line2[1],line2[0],p1,p2) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[0],line2[1],p1,p2) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[1],line2[0],p2,p1) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[0],line2[1],p2,p1) == null:
			visible = visible and true
		else:
			visible = visible and false
			return visible		
	return visible
	

func node_from_nodes(x):
	for y in self.nodes:
		if y.vector == x:
			return y
	return null
	

func visibilityGraphEasiest(S,vertexes,node,createLines : bool = false):
	var V = []
	for vert in vertexes:
		for c in vert:
			V.append(c)
	var E =[]
	var lados = []
	lados.resize(V.size()*V.size())
	lados.fill([])
	var counter = 0
	var c=0
	for i in range(V.size()):
		for j in range(V.size()):
			if j!=i:
				if visibleF(V[i],V[j],S,node):
					
					lados[i].append(j)
					var line = Line2D.new()
					line.add_point(V[i],0)
					line.add_point(V[j],1)
					line.default_color = Color.AQUAMARINE
					line.width = 1
					if createLines:
						node.add_child(line)
					E.append([V[i],V[j]])
					var v1 = NodeR.new(V[i])
					v1.name = str(i)
					nodes.append(v1)
					var v2 = NodeR.new(V[j])
					v2.name = str(j)
					nodes.append(v2)
				else:
					continue
			else:
				continue
	for lado in E:
		var connection = Connection.new()
		connection.fromNode = node_from_nodes(lado[0])
		connection.toNode = node_from_nodes(lado[1])
		connection.cost = lado[0].distance_to(lado[1])
		connections.append(connection)
	return E
			

func naiveBetterAlgorithm(point,S,vertexes,l):
	var V = []
	l.add_point(point,0)
	var sum = 1
	for obstacle in vertexes:
		for vertex in obstacle:
			#vertex, point vector2
			var r = point.distance_to(vertex)
			var angle = vertex.angle_to_point(point)
			var x = r*cos(angle)
			var y = r*sin(angle)
			l.add_point(Vector2(x,y),sum)
			V.append(Vector2(x,y))
			
			sum+=1
	print(V)
	return V
	
	

func createNodesVisibility() -> void:
	pass

func createConnectionsVisibility() -> Array:
	return []

func createNodesNavMesh() -> void:
	pass

func createConnectionsNavMesh() -> Array:
	return []

func get_connections(node):
	for connection in connections:
		if connection.fromNode == node:
			return connection

func pathfindDijkstra(graph: Graph,start: NodeR,end: NodeR) -> Array:#[]
	var startRecord = NodeRecord.new()
	startRecord.node = start
	var connecction = get_connections(start)
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
					open.add(endNodeRecord)
		
		# We’ve finished looking at the connections for the 
		# current node, so add it to the closed list and 
		# remove it from the open list.
		open.delete(current) #-= current
		closed.add(current) #+= current
		

		# We’re here if we’ve either found the goal, or if we’ve
		# no more nodes to search, find which.
	if current.node != goal:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		return []
	else:
	# Compile the list of connections in the path.
	# Work back along the path, accumulating connections.
		while current.node != start:
			path.append(current.connection)
			
			var fromN = current.connection.getFromNode()
			current = graph.getToConnections(fromN, current.connection.cost)
# Reverse the path, and return it.
		return path #reverse





func pathfindAStar(graph: Graph, start: NodeR, end: NodeR, heuristic: Heuristic,N) -> Array:
	# This structure is used to keep track of the 
	# information we need for each node.
	# Initialize the record for the start node.
	var startRecord = NodeRecord.new()
	startRecord.node = start
	startRecord.connection = get_connections(start)
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
		
		if current.node.vector == goal.vector:
			break
		
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
			var endNodeRecord
			var endNodeHeuristic
			if closed.contains(endNode):
			# Here we find the record in the closed list 
			# corresponding to the endNode.
				endNodeRecord = closed.find(endNode)
				# If we didn’t find a shorter route, skip.
				if endNodeRecord.costSoFar <= endNodeCost:
					continue
				# Otherwise remove it from the closed list.
				closed.delete(endNodeRecord)
			# We can use the node’s old cost values to 
			# calculate its heuristic without calling the 
			# possibly expensive heuristic function.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Skip if the node is open and we’ve not 
	  # found a better route.
			elif open.contains(endNode):
		# Here we find the record in the open list 
		# corresponding to the endNode.
				endNodeRecord = open.find(endNode)
		# If our route is no better, then skip.
				if endNodeRecord.costSoFar <= endNodeCost:
					continue
		# Again, we can calculate its heuristic.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Otherwise we know we’ve got an unvisited 
	  # node, so make a record for it.
			else:
				endNodeRecord = NodeRecord.new()
				endNodeRecord.node = endNode

				# We’ll need to calculate the heuristic 
				# value using the function, since we don’t 
				# have an existing record to use.
				endNodeHeuristic = heuristic.estimate(endNode)

			# We’re here if we need to update the node. Update the 
			# cost, estimate and connection.
			endNodeRecord.cost = endNodeCost
			endNodeRecord.connection = connection
			endNodeRecord.costSoFar = endNodeCost
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
	if current.node.vector != goal.vector:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		return []
	
	# Compile the list of connections in the path.
	var path = []

	# Work back along the path, accumulating 
	# connections.
	var costs = 0
	var path_of_vectors = [current.connection.toNode.vector]
	var dict = {}
	dict[current.connection.toNode.vector] = 1
	while current.node.vector != start.vector: #coun<30: #
		path.append(current.connection)
		costs+=current.cost
		if dict.has(current.connection.toNode.vector):
			var arr = [current.connection.fromNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.fromNode.vector] = 1
			#path_of_vectors.append(current.connection.fromNode.vector)
		elif dict.has(current.connection.fromNode.vector):
			var arr = [current.connection.toNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.toNode.vector] = 1
		var fromN = current.connection.getFromNode()
		var a = closed.find(fromN)
		current = a 
	
	# Reverse the path, and return it.
	return path_of_vectors
	


func pathfindAStarCost(graph: Graph, start: NodeR, end: NodeR, heuristic: Heuristic,N, t : Tactic) -> float:
	# This structure is used to keep track of the 
	# information we need for each node.
	# Initialize the record for the start node.
	var startRecord = NodeRecord.new()
	startRecord.node = start
	startRecord.connection = get_connections(start)
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
		if current.node.vector == goal.vector:
			break

	# Otherwise get its outgoing connections.
		var connections = graph.getConnections(current)

		# Loop through each connection in turn.
		for connection in connections:
			# Get the cost estimate for the end node.
			var endNode = connection.getToNode()
			var endNodeCost = current.costSoFar + connection.getCost()			
			var costly = t.weight(connection.getFromNode(),endNode) * t.tactic(connection.getFromNode(),endNode)
			endNodeCost += costly
			# If the node is closed we may have to skip, or 
			# remove it from the closed list.
			var endNodeRecord
			var endNodeHeuristic
			if closed.contains(endNode):
			# Here we find the record in the closed list 
			# corresponding to the endNode.
				endNodeRecord = closed.find(endNode)
				# If we didn’t find a shorter route, skip.
				if endNodeRecord.costSoFar <= endNodeCost :
					continue
				# Otherwise remove it from the closed list.
				closed.delete(endNodeRecord)
			# We can use the node’s old cost values to 
			# calculate its heuristic without calling the 
			# possibly expensive heuristic function.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Skip if the node is open and we’ve not 
	  # found a better route.
			elif open.contains(endNode):
		# Here we find the record in the open list 
		# corresponding to the endNode.
				endNodeRecord = open.find(endNode)
			
		# If our route is no better, then skip.
				#cambiar por mayor que
				if endNodeRecord.costSoFar <= endNodeCost :
					continue
		# Again, we can calculate its heuristic.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Otherwise we know we’ve got an unvisited 
	  # node, so make a record for it.
			else:
				endNodeRecord = NodeRecord.new()
				endNodeRecord.node = endNode

				# We’ll need to calculate the heuristic 
				# value using the function, since we don’t 
				# have an existing record to use.
				endNodeHeuristic = heuristic.estimate(endNode)

			# We’re here if we need to update the node. Update the 
			# cost, estimate and connection.
			endNodeRecord.cost = endNodeCost
			endNodeRecord.connection = connection
			endNodeRecord.costSoFar = endNodeCost
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
	if current.node.vector != goal.vector:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		return -1
	
	# Compile the list of connections in the path.
	var path = []

	# Work back along the path, accumulating 
	# connections.	
	var costo = 0
	var path_of_vectors = [current.connection.toNode.vector]
	var dict = {}
	dict[current.connection.toNode.vector] = 1

	var visited = []
	while current.node.vector != start.vector:
		path.append(current.connection)
		costo+= current.cost
		if dict.has(current.connection.toNode.vector):
			var arr = [current.connection.fromNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.fromNode.vector] = 1
		elif dict.has(current.connection.fromNode.vector):
			var arr = [current.connection.toNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.toNode.vector] = 1
		var fromN = current.connection.getFromNode()
		var a = closed.find(fromN)
		current = a
		if current.connection not in visited:
			visited.append(current.connection)
		else:
			break
	
	if start.vector not in path_of_vectors or goal.vector not in path_of_vectors:
		costo = -1	
	# Reverse the path, and return it.
		
	return costo



func closest_to_node(position : Vector2):
	var min = INF
	var selected = null
	for node in nodes:
		if position.distance_to(node.vector) < min:
			min = position.distance_to(node.vector)
			selected = node
	return selected

func getTo(toNode:NodeR, cost : float,costSoFar : float) -> NodeRecord:
	for c in connections:
		if c.toNode.vector == toNode.vector or c.toNode.name == toNode.name:
			if c.cost == cost:
				var a = NodeRecord.new()
				a.node = toNode
				a.connection = c
				a.costSoFar = costSoFar-a.connection.cost
				a.cost = a.connection.cost
				return a
	return NodeRecord.new()
	
	
	#costsoFar = current.costSoFar + connection.getCost()




func pathfindAStarModified(graph: Graph, start: NodeR, end: NodeR, heuristic: Heuristic,N, t : Tactic) -> Array:
	# This structure is used to keep track of the 
	# information we need for each node.
	# Initialize the record for the start node.
	var startRecord = NodeRecord.new()
	startRecord.node = start
	startRecord.connection = get_connections(start)
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
		if current.node.vector == goal.vector:
			break

	# Otherwise get its outgoing connections.
		var connections = graph.getConnections(current)

		# Loop through each connection in turn.
		for connection in connections:
			# Get the cost estimate for the end node.
			var endNode = connection.getToNode()
			var endNodeCost = current.costSoFar + connection.getCost()			
			var costly = t.weight(connection.getFromNode(),endNode) * t.tactic(connection.getFromNode(),endNode)
			endNodeCost += costly
			# If the node is closed we may have to skip, or 
			# remove it from the closed list.
			var endNodeRecord
			var endNodeHeuristic
			if closed.contains(endNode):
			# Here we find the record in the closed list 
			# corresponding to the endNode.
				endNodeRecord = closed.find(endNode)
				# If we didn’t find a shorter route, skip.
				if endNodeRecord.costSoFar <= endNodeCost :
					continue
				# Otherwise remove it from the closed list.
				closed.delete(endNodeRecord)
			# We can use the node’s old cost values to 
			# calculate its heuristic without calling the 
			# possibly expensive heuristic function.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Skip if the node is open and we’ve not 
	  # found a better route.
			elif open.contains(endNode):
		# Here we find the record in the open list 
		# corresponding to the endNode.
				endNodeRecord = open.find(endNode)
			
		# If our route is no better, then skip.
				#cambiar por mayor que
				if endNodeRecord.costSoFar <= endNodeCost :
					continue
		# Again, we can calculate its heuristic.
				endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar
	  # Otherwise we know we’ve got an unvisited 
	  # node, so make a record for it.
			else:
				endNodeRecord = NodeRecord.new()
				endNodeRecord.node = endNode

				# We’ll need to calculate the heuristic 
				# value using the function, since we don’t 
				# have an existing record to use.
				endNodeHeuristic = heuristic.estimate(endNode)

			# We’re here if we need to update the node. Update the 
			# cost, estimate and connection.
			endNodeRecord.cost = endNodeCost
			endNodeRecord.connection = connection
			endNodeRecord.costSoFar = endNodeCost
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
	if current.node.vector != goal.vector:
	# We’ve run out of nodes without finding the goal, so 
	# there’s no solution.
		return []
	
	# Compile the list of connections in the path.
	var path = []

	# Work back along the path, accumulating 
	# connections.	
	var costo = 0
	var path_of_vectors = [current.connection.toNode.vector]
	var dict = {}
	dict[current.connection.toNode.vector] = 1

	var visited = []
	while current.node.vector != start.vector:
		path.append(current.connection)
		costo+= current.cost
		if dict.has(current.connection.toNode.vector):
			var arr = [current.connection.fromNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.fromNode.vector] = 1
		elif dict.has(current.connection.fromNode.vector):
			var arr = [current.connection.toNode.vector]
			arr.append_array(path_of_vectors)
			path_of_vectors = arr
			dict[current.connection.toNode.vector] = 1
		var fromN = current.connection.getFromNode()
		var a = closed.find(fromN)
		current = a
		if current.connection not in visited:
			visited.append(current.connection)
		else:
			break
	
	if start.vector not in path_of_vectors or goal.vector not in path_of_vectors:
		path_of_vectors = []
	# Reverse the path, and return it.
		
	return path_of_vectors

func get_connections_nodes(node):
	var co = []
	for connection in connections:
		if connection.fromNode == self.nodes[node]:
			co.append(connection.toNode)
	var pos  =[]
	for x in range(self.nodes.size()):
		for y in co:
			if y.vector == self.nodes[x].vector:
				pos.append(x)
	return pos
				

func changeConnections(nodes):
	for x in nodes:
		var node = self.closest_to_node(x)
		for connection in self.connections:
			if connection.fromNode == node or connection.toNode == node:
				connection.cost += 10000

var rng = RandomNumberGenerator.new()    
	
func random_node():
	rng.randomize()
	var r = rng.randf_range(0,self.nodes.size()-1)
	return self.nodes[r]
