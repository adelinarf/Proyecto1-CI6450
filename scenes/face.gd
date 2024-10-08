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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	target = get_node("Player")
	new = Face.new(character,target)
	new2 = Face.new(character2,target)
	new3 = Face.new(character3,target)
	new4 = Face.new(character4,target)
	new5 = Face.new(character5,target)
	character.disableCollisionArrow()
	character2.disableCollisionArrow()
	character3.disableCollisionArrow()
	character4.disableCollisionArrow()
	character5.disableCollisionArrow()
	character.disableWanderElements()
	character2.disableWanderElements()
	character3.disableWanderElements()
	character4.disableWanderElements()
	character5.disableWanderElements()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
	character2.steering = new2.getSteering()
	character3.steering = new3.getSteering()
	character4.steering = new4.getSteering()
	character5.steering = new5.getSteering()
