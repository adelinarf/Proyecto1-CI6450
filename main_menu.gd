extends Node2D

func setPerpendicular(vec : Vector2, dir : float):
	var tempVec := vec
	vec.x = vec.y
	vec.y = tempVec.x
	if(dir != 0):
		vec.x *= -1
	else:
		vec.y *= -1
	'''
	var val = 1
	#print(dir)	
	if -3.14 <= dir and dir <= -3.15: #arriba
		print("arriba")
		vec.y *= val
	elif dir == 0: #abajo
		print("abajo")
		vec.y *= -val
	elif 1.57 <= dir and dir <= 1.58: #izquierda
		print("izquierda")
		vec.x *= val
	elif -1.57 <= dir and dir <= -1.58: #derecha
		print("derecha")
		vec.x *= -val
	elif -3.14 < dir and dir <-1.57: #derecha arriba
		print("derecha arriba")
		vec.x *= -val
		vec.y *= val
	elif -3.15 < dir and dir<-1.57: #izquierda arriba
		print("izquierda arriba")
		vec.x *= val
		vec.y *= val
	elif 0 < dir and dir < 1.57: #izquierda abajo
		print("izquierda abajo")
		vec.x *= val
		#vec.y *= -val
	elif (1.57 < dir and dir < 4):
		print("ESTE")
	elif -1.57 < dir and dir < 0: #derecha abajo
		print("derecha abajo")
		vec.x *= -val
		vec.y *= val
	else:
		vec.x *= -val
	'''
	
	return vec	

func detectCollisionCharacter(char):
	var detector = CollisionDetector.new(layer)
	var ray = char.velocity
	ray.normalized()
	ray *= 3 #0.1
	var collision = detector.getCollision(char.position, ray)
	
	if collision.position != Vector2.ZERO:
		char.velocity = setPerpendicular(char.velocity,char.orientation)
	return char.steering

# Called when the node enters the scene tree for the first time.
func getNodes(name : String,start : int, number : int) -> Array:
	var arr = []
	for x in range(start,number+1):
		arr.append(get_node(name+str(x)))
	return arr
	
var layer = []
var character 
var character2
var seek
var wander

func _ready() -> void:
	character = get_node("Character")
	character2 = get_node("Character2")
	character.disableArrows()
	character.disableCollisions()
	character2.disableArrows()
	character2.disableCollisions()
	layer.append_array(getNodes("wall",1,23))
	seek = Seek.new(character,character2)
	inst_follow = FollowPath.new(character2,character,positions)

var positions = [Vector2(640,555), Vector2(643,89),Vector2(-3.216,3.102),Vector2(48,555)]
var inst_follow
# Called every frame. 'delta' is the elapsed time since the previous frame.
func reverse(list):
	var a = []
	for x in range(list.size()-1,-1,-1):
		a.append(list[x])
	return a

func _process(delta: float) -> void:
	character.steering = seek.getSteering()
	#character.steering = wander.getSteeringToPos(positions)
	character.steering = detectCollisionCharacter(character)
	var following = inst_follow.walk_all()
	if following != null:
		character2.time=0.1
		character2.steering = following
	else:
		inst_follow.positions = reverse(positions)
		inst_follow.pos = 0


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tactical_path_finding.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
