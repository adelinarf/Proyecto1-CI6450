class_name ObstacleAvoidance
extends Seek

var detector: CollisionDetector

# The minimum distance to a wall (i.e., 
# how far to avoid collision) should be 
# greater than the radius of the character.
var avoidDistance: float = 55.0

# The distance to look ahead for a 
# collision (i.e., the length of the 
# collision ray).
var lookahead: float = 10.0
var nodes
var sprite

func _init(character: CharacterBody2D, target, nodes,sprite) -> void:
	super(character,target)
	self.nodes = nodes
	detector = CollisionDetector.new(nodes)
	self.sprite=sprite
	
func getSteering() -> SteeringOutput:
 # 1. Calculate the target to delegate to seek
 # Calculate the collision ray vector.
	var ray = character.velocity
	ray.normalized()
	ray *= lookahead
	
	character.arrow_position(ray)

	 # Find the collision
	var collision = detector.getCollision(character.position, ray)

	 # If have no collision, do nothing.
	if collision.position == Vector2.ZERO:
		return SteeringOutput.new(Vector2(0.0,0.0),0.0)	
	sprite.position = collision.position
	 # 2. Otherwise create a target and delegate to seek.
	#var new = collision.position + collision.normal * avoidDistance
	#new = Vector2.UP
	#character.position -= ( new - character.position).normalized()
	character.velocity = -character.velocity
	return super.getSteering()
