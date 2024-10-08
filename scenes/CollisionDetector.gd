class_name CollisionDetector

var nodes
func _init(nodes) -> void:
	self.nodes = nodes

func getCollision(position : Vector2, moveAmount: Vector2) -> Collision:
	var positionCollision = Vector2.ZERO
	var normal = Vector2.ZERO
	for node in self.nodes:
		var h = node.texture.get_height()
		var w = node.texture.get_width()
		var r = (h/2+pow(w,2))/(8*h)
		if (moveAmount+position).distance_to(node.position) < r:
			#normal = (moveAmount+position).cross(node.position) 
			normal = Vector2.UP
			return Collision.new(moveAmount+position, normal)
		
	return Collision.new(positionCollision, normal)
