class_name SteeringOutput

var lineal = Vector2(1.0,0.0)
var angular = 0.0

func _init(lineal : Vector2, angular : float) -> void:
	lineal = lineal
	angular = angular
	
func _lineal() -> Vector2:
	return lineal

func _angular() -> float:
	return angular
