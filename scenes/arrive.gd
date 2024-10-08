extends Node

var character
var target
var new
func _ready():
	character = get_node("Character")
	target = get_node("Player")
	new = Arrive.new(character,target)
	character.disableArrows()
	target.disableArrows()
	
func _process(delta: float) -> void:
	character.steering = new.getSteering()
