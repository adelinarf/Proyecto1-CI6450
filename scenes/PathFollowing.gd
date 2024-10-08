class_name FollowPath
extends Seek

var path : Path
 # The distance along the path to generate the 
# target. Can be negative if the character is 
# moving in the reverse direction.
var pathOffset :float = 0.5
# The current position on the path.
var currentParam : float
var currentPos : float = -1
var positions

func _init(character : CharacterBody2D, target : CharacterBody2D, grid) -> void:
	super(character,target)
	path = Path.new(grid)
	self.positions = grid

func getSteering() -> SteeringOutput:
	# 1. Calculate the target to delegate to face.
	# Find the current position on the path.
	currentParam = path.getParam(character.position, currentPos)
	#currentPos = currentParam
 # Offset it.
	var targetParam = fmod(currentParam + pathOffset,self.positions.size())
	# Get the target position.
	character.position = path.getPosition(targetParam) 


	# 2. Delegate to seek.
	return super.getSteering()


# The time in the future to predict the 
# character’s position.
var predictTime: float = 0.00001

func getSteeringPrediction() -> SteeringOutput:
	# 1. Calculate the target to delegate to face.
	# Find the predicted future location.
	var futurePos = target.position + target.velocity * predictTime

	# Find the current position on the path.
	currentParam = path.getParam(futurePos, currentPos)

	# Offset it.
	var targetParam = fmod(currentParam + pathOffset,self.positions.size())
	# Get the target position.
	character.position += ( path.getPosition(targetParam) - character.position).normalized()

	# 2. Delegate to seek
	return super.getSteering()
