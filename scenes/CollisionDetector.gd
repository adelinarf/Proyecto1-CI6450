class_name CollisionDetector

var nodes
func _init(nodes) -> void:
	self.nodes = nodes

func getCollision(position : Vector2, moveAmount: Vector2) -> Collision:
	var positionCollision = Vector2.ZERO
	var normal = Vector2.ZERO
	#print(self.nodes,nodes)
	for node in self.nodes:
		var h = node.texture.get_height()
		var w = node.texture.get_width()
		var r = ((h/2)+pow(w,2))/(8*h)+20
		if (moveAmount+position).distance_to(node.position) <= r or (position).distance_to(node.position) <= r:
			#normal = (moveAmount+position).cross(node.position) 
			normal = Vector2.UP
			return Collision.new(moveAmount+position, normal)
		
	return Collision.new(positionCollision, normal)
	

func getCollision2(position : Vector2, moveAmount: Vector2) -> Collision:
	var positionCollision = Vector2.ZERO
	var normal = Vector2.ZERO
	#print(self.nodes,nodes)
	for node in self.nodes:
		var r = 100
		#print((moveAmount+position).distance_to(node.position) <= r)
		if (moveAmount+position).distance_to(node.position) <= r or (position).distance_to(node.position) <= r:
			#normal = (moveAmount+position).cross(node.position) 
			normal = Vector2.UP
			return Collision.new(moveAmount+position, normal)
		
	return Collision.new(positionCollision, normal)


func getCollision3(position : Vector2, moveAmount: Vector2):
	var positionCollision = Vector2.ZERO
	var normal = Vector2.ZERO
	#print(self.nodes,nodes)
	for node in self.nodes:
		var r = 100
		#print((moveAmount+position).distance_to(node.position) <= r)
		if (moveAmount+position).distance_to(node.position) <= r or (position).distance_to(node.position) <= r:
			#normal = (moveAmount+position).cross(node.position) 
			normal = Vector2.UP
			return node
		
	return null
