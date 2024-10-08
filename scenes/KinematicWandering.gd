class_name KinematicWandering

var character
var maxSpeed: float = 2
var maxRotation: float = 30

func randomBinomial () -> float:
	randomize()
	return randf_range(0,1)-randf_range(0,1)
	

func _init(character : CharacterBody2D) -> void:
	self.character=character
	
func getSteering() -> KinematicSteeringOutput:
	var result = KinematicSteeringOutput.new(Vector2(0.0,0.0),0.0)

	# Get velocity from the vector form of the orientation.
	var y = self.character.polarToCard(self.character.orientation)
	print(self.character.orientation)
	result.velocity = Vector2(randomBinomial() * maxRotation,maxSpeed * self.character.orientation)

	# Change our orientation randomly.
	self.character.orientation=randomBinomial() * maxRotation
	result.rotation = 0 #randomBinomial() * maxRotation
	
	return result
