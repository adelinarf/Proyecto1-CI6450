class_name Wander
extends Face

# The radius and forward offset of the 
# wander circle.
var wanderOffset: float = 100.0
var wanderRadius: float = 50.0
# The maximum rate at which the wander 
# orientation can change.
var wanderRate: float = 1000
# The current orientation of the wander target.
var wanderOrientation: float = 2.6
# The maximum acceleration of the charact0er.
var maxAcceleration: float = 5.0

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	super(character,target)
	randomize()
	wanderOrientation =randf_range(-10.0,10.0)
	
func randomBinomial () -> float:
	randomize()
	return randf_range(0,1)-randf_range(0,1)
	

func setPosition(pos) -> Vector2:
	#x entre 17 y 1100
	#y entre 3 y 540
	var x = fmod(pos.x,1100)
	var y = fmod(pos.y,540)
	return Vector2(x,y)
	
func getSteering() -> SteeringOutput:
	wanderOrientation += randomBinomial() * wanderRate
	var targetOrientation = wanderOrientation + character.orientation
	# Calculate the center of the wander circle.
	var v2 = Vector2.from_angle(character.orientation)
	var targetP = character.position + wanderOffset * v2
	character.change_circle_pos(targetP,wanderRadius)

	# Calculate the target location.
	var v3 = Vector2.from_angle(targetOrientation)
	targetP += wanderRadius * v3
	character.change_target_pos(targetP)
	character.position += ( targetP- character.position).normalized()

	# 2. Delegate to face.
	var result = super.getSteering()

	# 3. Now set the linear acceleration to be at full
	# acceleration in the direction of the orientation.
	var v = Vector2.from_angle(character.orientation)
	result.lineal = (maxAcceleration * v) 
	return result
