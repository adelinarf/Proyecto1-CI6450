extends Node2D

func getNodes(name : String,start : int, number : int) -> Array:
	var arr = []
	for x in range(start,number+1):
		#print(x,"GETNODES")
		arr.append(get_node(name+str(x)))
	return arr
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_node("Player")
	player.disableArrows()
	player.disableCollisions()
	var fire = getNodes("campfire",1,5)
	for f in fire:
		f.play("move")
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
