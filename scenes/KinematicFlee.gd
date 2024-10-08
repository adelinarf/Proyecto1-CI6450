class_name KinematicFlee

var character
var target
var maxSpeed: float = 0.01
   
func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target
	
func getSteering() -> KinematicSteeringOutput:
	var result = KinematicSteeringOutput.new(Vector2(0.0,0.0),0.0)
	 # Get the direction to the target.
	result.velocity = target._position() - character._position()
	result.velocity.normalized()
	result.velocity *= -maxSpeed
	character.skew = 0 
	result.rotation = 0
	return result
