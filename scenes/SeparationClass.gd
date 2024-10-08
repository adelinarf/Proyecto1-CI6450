class_name Separation

var character
var maxAcceleration: float = 200
# A list of potential targets.
var targets

# The threshold to take action.
var threshold: float = 100.0

# The constant coefficient of decay for 
# the inverse square law.
var decayCoefficient: float = 500

func _init(character : CharacterBody2D, targets) -> void:
	self.character = character
	self.targets = targets

func getSteering(result : SteeringOutput) -> SteeringOutput:
	# Loop through each target.
	for target in targets:
		# Check if the target is close.
		var direction = character.position - target.position
		var distance = direction.length()
	
		if distance < threshold:
			# Calculate the strength of repulsion
			# (here using the inverse square law).
			var strength = min(decayCoefficient / (distance * distance),maxAcceleration)

			# Add the acceleration.
			direction = direction.normalized()
			result.lineal = strength * direction
	return result
