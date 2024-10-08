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
func getNodes(name : String, number : int) -> Array:
	var arr = []
	for x in range(1,number+1):
		#print(x)
		arr.append(get_node(name+str(x)))
	return arr

func _ready() -> void:
	var children = get_children()
	#print(children) # Replace with function body.
	#print(children[0].position)
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	target = get_node("Player")
	character.disableCollisions()
	character2.disableCollisions()
	character3.disableCollisions()
	character4.disableCollisions()
	character5.disableCollisions()
	target.disableCollisions()
	character.disableOrientationArrow()
	character2.disableOrientationArrow()
	character3.disableOrientationArrow()
	character4.disableOrientationArrow()
	character5.disableOrientationArrow()
	
	character.disableWanderElements()
	character2.disableWanderElements()
	character3.disableWanderElements()
	character4.disableWanderElements()
	character5.disableWanderElements()
	
	target.disableArrows()
	var sprite = get_node("Sprite2D")
	var layer = []
	layer.append_array(getNodes("bridge",48))
	layer.append_array(getNodes("bush",5))
	layer.append_array(getNodes("mushroom",3))
	layer.append_array(getNodes("pumpkin",3))
	layer.append_array(getNodes("water",16))
	layer.append_array(getNodes("rock",7))
	layer.append(get_node("house"))	
	#print(layer)
	new = ObstacleAvoidance.new(character,target,layer,sprite)
	new2 = ObstacleAvoidance.new(character2,target,layer,sprite)
	new3 = ObstacleAvoidance.new(character3,target,layer,sprite)
	new4 = ObstacleAvoidance.new(character4,target,layer,sprite)
	new5 = ObstacleAvoidance.new(character5,target,layer,sprite)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteering()
	character2.steering = new2.getSteering()
	character3.steering = new3.getSteering()
	character4.steering = new4.getSteering()
	character5.steering = new5.getSteering()
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
