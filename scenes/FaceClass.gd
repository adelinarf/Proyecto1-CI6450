class_name Face
extends Align

var target2:CharacterBody2D

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	super(character,target)
	self.target2 = target
	
func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)
	var direction = target.position - character.position

	# Check for a zero direction, and make no change if so.
	if direction.length() == 0:
		return SteeringOutput.new(Vector2(0.0,0.0),0.0)

	# 2. Delegate to align.
	character.orientation = atan2(-direction.x,direction.y)
	return super.getSteering()
