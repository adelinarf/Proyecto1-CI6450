extends Node2D

var character
var target
var maxAcceleration: float = 0.01

var new
func _ready():
	character = get_node("Character")
	target = get_node("Player")
	new = Seek.new(character,target)
	target.disableArrows()
	character.disableArrows()
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
