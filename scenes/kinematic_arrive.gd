extends Node2D

var character
var target
var new

func _ready():
	character = get_node("Character")
	target = get_node("Player")
	new = KinematicArriving.new(character,target)
	character.disableArrows()
	target.disableArrows()
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
