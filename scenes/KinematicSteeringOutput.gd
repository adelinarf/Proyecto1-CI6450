class_name KinematicSteeringOutput

var velocity = Vector2(1.0,0.0)
var rotation = 0.0

func _init(velocity: Vector2, rotation : float) -> void:
	velocity = velocity
	rotation = rotation
	
func _velocity() -> Vector2:
	return velocity

func _rotation() -> float:
	return rotation
