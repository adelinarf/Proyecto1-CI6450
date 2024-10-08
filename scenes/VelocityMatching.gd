class_name VelocityMatching

extends Node2D

var character
var target
var maxAcceleration: float = 0.01
# The time over which to achieve target speed.
var timeToTarget = 0.1
	

func _init(character : CharacterBody2D, target : CharacterBody2D) -> void:
	self.character = character
	self.target = target

func getSteering() -> SteeringOutput:
	var result = SteeringOutput.new(Vector2(0.0,0.0),0.0)

	# Acceleration tries to get to the target velocity.
	result.lineal = target.velocity - character.velocity
	result.lineal /= timeToTarget

	# Check if the acceleration is too fast.
	if result.lineal.length() > maxAcceleration:
		result.lineal.normalized()
		result.lineal *= maxAcceleration
	result.angular = 0
	return result
	
