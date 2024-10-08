extends Node2D

var character
var character2
var character3
var character4
var character5

var target
var new
var new2
var new3
var new4
var new5

var multiples = 0

func _ready() -> void:
	randomize()
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	target = get_node("Player")
	new = Wander.new(character, target)
	new2 = Wander.new(character2,target)
	new3 = Wander.new(character3,target)
	new4 = Wander.new(character4,target)
	new5 = Wander.new(character5,target)
	target.disableArrows()
	character.disableArrows2()
	character2.disableArrows2()
	character3.disableArrows2()
	character4.disableArrows2()
	character5.disableArrows2()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
	character2.steering = new2.getSteering()
	character3.steering = new3.getSteering()
	character4.steering = new4.getSteering()
	character5.steering = new5.getSteering()
	
