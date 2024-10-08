class_name Align 

var character :CharacterBody2D
var target:CharacterBody2D
var maxAngularAcceleration: float = 1
var maxRotation: float = 20
  # The radius for arriving at the target.
var targetRadius: float = 0.4
  # The radius for beginning to slow down.
var slowRadius: float = 100
  # The time over which to achieve target speed.
var timeToTarget: float = 1

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target
	
func mapToRange (angle : float) -> float:
	return fmod((angle + PI),(2 * PI)) - PI
	
func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)
	var rotation = self.target.orientation - self.character.orientation
	# Map the result to the (-pi, pi) interval.
	
	rotation = mapToRange(rotation)
	var rotationSize = abs(rotation)
	# Check if we are there, return no steering.
	if rotationSize < targetRadius: 
		return SteeringOutput.new(Vector2(0.0,0.0),0.0)
# If we are outside the slowRadius, then 
	# use maximum rotation.
	var targetRotation
	if rotationSize > slowRadius:
		targetRotation = maxRotation
	# Otherwise calculate a scaled rotation.
	else:
		targetRotation = maxRotation * rotationSize / slowRadius

	# The final target rotation combines speed (already in the
	# variable) and direction.
	targetRotation *= rotation / rotationSize
	
	# Acceleration tries to get to the target rotation.
	result.angular = targetRotation - self.character.orientation
	result.angular /= timeToTarget
	
	# Check if the acceleration is too great.
	var angularAcceleration = abs(result.angular)
	if angularAcceleration > maxAngularAcceleration:
		result.angular /= angularAcceleration
		result.angular *= maxAngularAcceleration
		
	result.lineal = Vector2(0.0,0.0)
	
	return result
	
