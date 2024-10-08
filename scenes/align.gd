extends Node2D

var character
var target
var new 

func _ready():
	character = get_node("Character")
	target = get_node("Player")
	new = Align.new(character,target)
	character.disableCollisionArrow()
	character.disableWanderElements()
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
