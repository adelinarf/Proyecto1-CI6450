extends Node2D

var character
var character2

var target
var new
var new2
func _ready() -> void:
	character = get_node("Character")
	character2 = get_node("Character2")
	target = get_node("Player")
	new = Pursue.new(character,target)
	new2 = Evade.new(character2,target)
	character.disableShow()
	character2.disableShow()
	target.disableArrows()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var n = LookWhereYoureGoing.new(character,target)
	character.steering = n.getSteering()
	character.steering = new.getSteering()
	
	var n2 = LookWhereYoureGoing.new(character2,target)
	character2.steering = n2.getSteering()
	character2.steering = new2.getSteering()
	
