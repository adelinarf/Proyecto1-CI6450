class_name LookWhereYoureGoing
extends Align

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	super._init(character,target)

func getSteering() -> SteeringOutput:	
	var velocity = character.velocity
	if velocity.length() == 0:
		return SteeringOutput.new(Vector2(0.0,0.0),0.0)

	# Otherwise set the target based on the velocity.
	character.orientation = atan2(-character.velocity.x, character.velocity.y)

	# 2. Delegate to align.
	return super.getSteering()
