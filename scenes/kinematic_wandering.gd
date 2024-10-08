extends Node2D

var character
var character2
var character3

var new
var new2
var new3
func _ready():
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	new = KinematicWandering.new(character)
	new2 = KinematicWandering.new(character2)
	new3 = KinematicWandering.new(character3)
	character.disableArrows()
	character2.disableArrows()
	character3.disableArrows()
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering =  new.getSteering()
	character2.steering =  new2.getSteering()
	character3.steering =  new3.getSteering()
