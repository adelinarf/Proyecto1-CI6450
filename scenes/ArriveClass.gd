class_name Arrive

var character
var target
var maxAcceleration = 0.1
var maxSpeed = 0.1
# The radius for arriving at the target. 
var targetRadius: float = 140.0
var targetSpeed = 20
# The radius for beginning to slow down. 
var slowRadius: float = 200.0
# The time over which to achieve target speed. 
var timeToTarget: float = 0.1 

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target
	
func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)
	# Get the direction to the target. 
	var direction = self.target._position() - self.character._position()
	var distance = direction.length()
	if distance < targetRadius: 
		return SteeringOutput.new(Vector2(0.0,0.0),0.0) 
	if distance > slowRadius:
		targetSpeed = maxSpeed 
	else: 
		targetSpeed = maxSpeed * distance / slowRadius 

	# The target velocity combines speed and direction.
	var targetVelocity = direction    
	targetVelocity.normalized() 
	targetVelocity *= targetSpeed 

	# Acceleration tries to get to the target velocity.    
	result.lineal = targetVelocity - character.velocity 
	result.lineal /= timeToTarget 
	
	if result.lineal.length() > maxAcceleration:
		result.lineal.normalized()
		result.lineal *= maxAcceleration 
	result.angular = 0.0
	return result
