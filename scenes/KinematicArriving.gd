class_name KinematicArriving

var character
var target
var maxSpeed = 0.1
var radius = 1
# The time over which to achieve target speed. 
var timeToTarget: float = 10

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target
	
func getSteering() -> KinematicSteeringOutput:
	var result = KinematicSteeringOutput.new(Vector2(0.0,0.0),0.0)
	# Get the direction to the target.
	result.velocity = target._position() - character._position()
	# Check if we’re within radius.
	if result.velocity.length() < radius:
		return KinematicSteeringOutput.new(Vector2(0.0,0.0),0.0)
	# We need to move to our target, we’d like
	# to get there in timeToTarget seconds.
	result.velocity /= timeToTarget
	# If this is too fast, clip it to the max 
	# speed.
	if result.velocity.length() > maxSpeed:
		result.velocity.normalized()
		result.velocity *= maxSpeed

	# Face in the direction we want to move.
	self.character.orientation = self.character.newOrientation(self.character.orientation,result.velocity)
	result.rotation = 0
	return result
