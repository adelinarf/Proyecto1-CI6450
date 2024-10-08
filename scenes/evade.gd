extends Node2D

var character
var target
var new
func _ready() -> void:
	character = get_node("Character")
	target = get_node("Player")
	new = Evade.new(character,target)
	character.disableArrows()
	target.disableArrows()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var n = LookWhereYoureGoing.new(character,target)
	character.steering = n.getSteering()
	character.steering = new.getSteering()
