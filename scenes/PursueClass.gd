class_name Pursue
extends Seek

var maxPrediction: float = 1
var parent
var explicitTarget
func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	super._init(character,target)
	self.explicitTarget = target
	
func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)
	var direction = target._position() - character._position()
	var distance = direction.length()
	var speed = character.velocity.length()
	var prediction
	# Check if speed gives a reasonable prediction time.
	if speed <= distance / maxPrediction:
		prediction = maxPrediction
	# Otherwise calculate the prediction time.
	else:
		prediction = distance / speed

	# Put the target together.
	target.position += target.velocity * prediction

	# 2. Delegate to seek.
	return super.getSteering()
