class_name Path

var total = 23

var positions

func _init(positions) -> void:
	self.positions = positions

func searchClosestPosition(position : Vector2) -> float:
	#position.distance_to()
	var closest = 10000
	var selected = 0
	for x in range(positions.size()):
		var dist = position.distance_to(Vector2(self.positions[x].x,self.positions[x].y))
		if dist < closest:
			closest = dist
			selected = x
	return selected
	
func getParam(position : Vector2, lastParam : float) -> float:
	return searchClosestPosition(position)

func getPosition(param : float) -> Vector2:
	return Vector2(self.positions[param].x,self.positions[param].y)
