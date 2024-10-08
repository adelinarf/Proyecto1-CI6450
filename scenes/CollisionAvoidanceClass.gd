class_name CollisionAvoidance

var character
var maxAcceleration : float = 3
var targets
# The collision radius of a character (assuming 
# all characters have the same radius here).
var radius : float = 50

func _init(character : CharacterBody2D, targets) -> void:
	self.character = character
	self.targets = targets

func getSteering() -> SteeringOutput:
	# 1. Find the target that’s closest to collision
	# Store the first collision time.
	var shortestTime: float = INF

	# Store the target that collides then, and 
	# other data that we will need and can avoid
	# recalculating.
	var firstTarget = null
	var firstMinSeparation: float
	var firstDistance: float
	var firstRelativePos: Vector2
	var firstRelativeVel: Vector2
   # Loop through each target.
	var relativePos
	for target in targets:
		# Calculate the time to collision
		relativePos = target.position - character.position
		var relativeVel = target.velocity - character.velocity
		var relativeSpeed = relativeVel.length()
		var timeToCollision = relativePos.dot(relativeVel)/(relativeSpeed * relativeSpeed)

	  # Check if it is going to be a collision at all.
		var distance = relativePos.length()
		var minSeparation = distance - relativeSpeed * timeToCollision
		#print(minSeparation,"SEPARATION")
		if minSeparation > 2 * radius:
			continue

	  # Check if it is the shortest.
		if timeToCollision > 0 and timeToCollision < shortestTime:
		# Store the time, target and other data.
			shortestTime = timeToCollision
			firstTarget = target
			firstMinSeparation = minSeparation
			firstDistance = distance
			firstRelativePos = relativePos
			firstRelativeVel = relativeVel
	# 2. Calculate the steering
	# If we have no target, then exit.
		if not firstTarget:
			return SteeringOutput.new(Vector2(0.0,0.0),0.0)

	# If we’re going to hit exactly, or if we’re already
	# colliding, then do the steering based on current position.
		if firstMinSeparation <= 0 or firstDistance < 2 * radius:
			relativePos = firstTarget.position - character.position

	# Otherwise calculate the future relative position.
		else:
			relativePos = firstRelativePos + firstRelativeVel * shortestTime

	# Avoid the target.
		relativePos = -relativePos.normalized()

	var result = SteeringOutput.new(relativePos * maxAcceleration,0.0)
	result.lineal = relativePos * maxAcceleration
	result.angular = 0
	return result
