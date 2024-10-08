class_name Flee

var character
var target
var maxAcceleration: float = 0.01

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target
	
func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)
	# Get the direction to the target.
	# Change to character.position - target.position
	# for flee
	result.lineal = target._position() - character._position()

	# Give full acceleration along this direction.
	result.lineal.normalized()
	result.lineal *= -maxAcceleration #DYNAMIC FLEE CON -MAXACCELERATION
	result.angular = 0
	return result  
