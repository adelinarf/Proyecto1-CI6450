extends Node2D

var V
var new
var new2
var character
var character2
var character3
var g1
var character4
var character5
var character6
var character7
var character8
var character9
var character10
var character11
var follow
var follow9
var follow10
var follow11
var seek11
var arrive11
var wander5

var lados
var global_tile_pos
var target
var graph_node_image_path = "res://sprites/background/red_crystal_0000.png"
var new_location_path = "res://sprites/background/green_crystal_0000.png"
const SCORE_TO_GET_TO_LAST_ROW = 100

const WALK = "walk"
const ATTACK = "attack"
const EVADE = "evade"
const FOLLOW_PATH = "follow"
const FOLLOW_PLAYER = "follow_player"
const THROW = "throw"
const UPDATE_TARGET = "update_target"

const WANDER = "wander"
const GUARD = "guard"
const CHANGE_WANDER_ORIENTATION = "changed_orientation_wander"
const FLEE = "flee"


const WALK_COLOR = Color.AQUA
const ATTACK_COLOR = Color.RED
const EVADE_COLOR = Color.MEDIUM_VIOLET_RED
const FOLLOW_PATH_COLOR = Color.ORCHID
const FOLLOW_PLAYER_COLOR = Color.ORANGE
const THROW_COLOR = Color.DARK_SEA_GREEN
const UPDATE_TARGET_COLOR = Color.FLORAL_WHITE
const WANDER_COLOR = Color.CORNFLOWER_BLUE
const FLEE_COLOR = Color.LAWN_GREEN
const GUARD_COLOR = Color.BLACK


var old_modulate = false
var old_modulation 
var differentiate = false
var color1 = Color.GREEN
var color2 = Color.RED
var color3 = Color.YELLOW
var color4 = Color.PURPLE
var color5 = Color.DEEP_PINK
var color6 = Color.ORANGE_RED
var color7 = Color.AQUA
var color8 = Color.DIM_GRAY
var color9 = Color.DARK_RED
var colors = [Color.WHITE,color1,color2,color3,color4,color5,color6,color7,color8,color9]

func getNodes(name : String,start : int, number : int) -> Array:
	var arr = []
	for x in range(start,number+1):
		arr.append(get_node(name+str(x)))
	return arr

func getNodesByNumber(name : String,list : Array) -> Array:
	var arr = []
	for x in list:
		arr.append(get_node(name+str(x)))
	return arr

func getAvailableNodes(name : String,start : int, number : int) -> Array:
	var arr = []
	for x in range(start,number+1):
		var n = get_node(name+str(x))
		if n!=null:
			arr.append(n)
	return arr
	
func vertexes_offset_pos(c1,POS : String = "ALL"):
	var offset = 50
	var left_upper = c1.position + Vector2(-c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	left_upper.x -= offset
	left_upper.y -= offset
	
	var left_down = c1.position + Vector2(-c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	left_down.x -= offset
	left_down.y += offset
	
	var right_upper = c1.position + Vector2(c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	right_upper.x += offset
	right_upper.y -= offset
	
	var right_down = c1.position + Vector2(c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	right_down.x += offset
	right_down.y += offset
	if POS=="LEFT_UP_DOWN":
		return [left_upper,left_down]
	elif POS == "LEFT_UP":
		return [left_upper]
	elif POS == "LEFT_DOWN":
		return [left_down]
	elif POS=="RIGHT_UP_DOWN":
		return [right_upper,right_down]
	elif POS == "RIGHT_UP":
		return [right_upper]
	elif POS == "RIGHT_DOWN":
		return [right_down]
	elif POS == "UP":
		return [left_upper,right_upper]
	elif POS == "DOWN":
		return [left_down,right_down]
		
		
	return [left_upper,left_down,right_upper,right_down]
	
func vertexes_offset(c1):
	var offset = 50
	var left_upper = c1.position + Vector2(-c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	left_upper.x -= offset
	left_upper.y -= offset
	
	var left_down = c1.position + Vector2(-c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	left_down.x -= offset
	left_down.y += offset
	
	var right_upper = c1.position + Vector2(c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	right_upper.x += offset
	right_upper.y -= offset
	
	var right_down = c1.position + Vector2(c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	right_down.x += offset
	right_down.y += offset
	return [left_upper,left_down,right_upper,right_down]

func vertexes(c1):
	var left_upper = c1.position + Vector2(-c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	
	var left_down = c1.position + Vector2(-c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	
	var right_upper = c1.position + Vector2(c1.texture.get_width()/2*0.4,-c1.texture.get_height()/2*0.38)
	
	var right_down = c1.position + Vector2(c1.texture.get_width()/2*0.4,c1.texture.get_height()/2*0.38)
	return [left_upper,left_down,right_upper,right_down]


func mapping(f : Array) -> Array:
	var a =[]
	for j in f:
		a.append(j.fromNode.name+" to "+j.toNode.name)
	return a

func distance_less_than(X,character,player):
	if character.position.distance_to(player.position) > X:
		return false
	else:
		return true
	
func player_is_visible(character,player):
	if g1.visibleF(player.position,character.position,all_vertexes,$"."):
		return true
	else:
		return false

func player_inside_path(character,player):
	for positions in global_tile_pos:
		if player.position.distance_to(positions) < 10:
			return true
	return false
	
func player_inside_perimeter(character,player):
	var X = 300
	if player.position.distance_to(character.position) < X:
		return true
	else:
		return false	

func decision1(character,player):
	var action2 = Action.new(WALK)
	var action = Action.new(ATTACK)
	var dec = Decision.new(action,action2,distance_less_than(100,character,player))
	var action3 = Action.new(GUARD)
	var d1 = Decision.new(dec,action3,player_is_visible(character,player))
	return d1 

func decision2(character,player):
	var action4 = Action.new(GUARD)
	var action5 = Action.new(EVADE)
	var action6 = Action.new(ATTACK)
	var dec2 = Decision.new(action5,action6,distance_less_than(200,character,player))
	var dec3 = Decision.new(action6,dec2,distance_less_than(100,character,player))
	var d2 = Decision.new(dec3,action4,player_is_visible(character,player))
	return d2

var follow_path_to = 0

func character_arrived_to_target(char,player):
	var pos
	if char == character:
		pos = follow_path_to
	elif char == character8:
		pos = follow_path_to_2
	elif char == character9:
		pos = follow_path_to_3
	elif char == character10:
		pos = follow_path_to_4
	elif char == character11:
		pos = follow_path_to_5
	
	if char.position.distance_to(global_tile_pos[pos]) < 50:
		return true
	else:
		return false
	
	if global_tile_pos[pos].y - 10 <= character.position.y and character.position.y <= global_tile_pos[pos].y + 10:
		if global_tile_pos[pos].x - 100 <= character.position.x and character.position.x <= global_tile_pos[pos].x + 100:
			return true
		else:
			return false
	return false
	
func decision3(character,player):
	var action7 = Action.new(FOLLOW_PATH)
	var action8 = Action.new(FOLLOW_PLAYER)
	var dec4 = Decision.new(action8,action7,player_inside_path(character,player))
	var action = Action.new(UPDATE_TARGET)
	var dec5 = Decision.new(action,action7,character_arrived_to_target(character,player))
	
	var d3 = Decision.new(dec4,dec5,player_inside_perimeter(character,player))
	return d3

func decision8(character,player):
	var action7 = Action.new(FOLLOW_PATH)
	var action8 = Action.new(THROW)
	var action = Action.new(UPDATE_TARGET)
	var dec4 = Decision.new(action8,action7,player_inside_path(character,player))
	
	var dec5 = Decision.new(action,action7,character_arrived_to_target(character,player))
	
	var d3 = Decision.new(dec4,dec5,player_inside_perimeter(character,player))
	return d3
	
func decision9(char,player):	
	var a1 = MachineAction.new(FOLLOW_PATH,3)
	var a2 = MachineAction.new(UPDATE_TARGET,3)
	var a3 = MachineAction.new(WALK,2)
	var a4 = MachineAction.new(ATTACK,1)
		
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a1,a4)
	
	var s4 = State.new(a4,a3,a1)
	
		
	#actions,targetState,condition
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t2 = Transition.new(MachineAction.new(WALK,2),s3,cond1)
	
	
	var cond2 = Condition.new()
	cond2.condition = character_arrived_to_target(char,player)
	var conditiont1 = AndCondition.new(cond2,NotCondition.new(cond1))
	var t1 = Transition.new(MachineAction.new(UPDATE_TARGET,3),s2,conditiont1)
	
	
	var condition3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var t3 = Transition.new(MachineAction.new(ATTACK,1),s4,condition3)
	
	var cond3 = FloatCondition.new(200,player.position.distance_to(char.position),100000)
	var t4 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,cond3)
	
	var cond4 = FloatCondition.new(50,char.position.distance_to(global_tile_pos[follow_path_to_5]),100000)
	var t5 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,cond4)
		
	s1.setTransitions([t2,t3,t1])
	s2.setTransitions([t3,t2,t5])
	s3.setTransitions([t3])
	s4.setTransitions([t4])	
	
	var machine = StateMachine.new(s1)
	return machine	
	
func decision4(character,player):
	var action9 = Action.new(GUARD)
	var action10 = Action.new(ATTACK)
	var action11 = Action.new(THROW)
	var dec5 = Decision.new(action10,action11,distance_less_than(200,character,player))
	var d4 = Decision.new(dec5,action9,player_is_visible(character,player))
	return d4



var obst
var arrive
var seek
var layer
var wander2
var evade
var arrive2
var seek2
var arrive3
var seek5
var flee5
var seek6
var attack5
var attack6
var seek7
var attack7

func findVertexes(array,constant):
	var nodes = getNodesByNumber("wall",array)
	var found = []
	for node in nodes:
		found.append_array(vertexes_offset_pos(node,constant))
	return found

func getVertexes():
	var vertex = []
	
	var left_up_down = [61,83]
	var right_up_down = []
	var right_down = [95,86]
	var down = [72,65,4,97]
	var right_up = [69,74]
	var left_up = [73]
	var left_down = [75,84,85,99,96,77]
	var up = [1]
	
	var vertex1 = findVertexes(left_up_down,"LEFT_UP_DOWN")
	var vertex2 = findVertexes(right_up_down,"RIGHT_UP_DOWN")
	var vertex3 = findVertexes(right_down,"RIGHT_DOWN")
	var vertex4 = findVertexes(down,"DOWN")
	var vertex5 = findVertexes(right_up,"RIGHT_UP")
	var vertex6 = findVertexes(left_up,"LEFT_UP")
	var vertex7 = findVertexes(left_down,"LEFT_DOWN")
	var vertex8 = findVertexes(up,"UP")
	
	vertex.append_array([vertex1,vertex2,vertex3,vertex4,vertex5,vertex6,vertex7,vertex8])
	return vertex

func changeWallsColor():
	var nodes = getAvailableNodes("wall",1,627)
	var modulate1 = nodes[0].modulate
	for node in nodes:
		node.modulate = modulate1

func closest_point_to(list, vector):
	var closest = 100000
	var selected = null
	for v in range(list.size()):
		if list[v].distance_to(vector) < closest:
			closest = list[v].distance_to(vector)
			selected = v
	return selected

var pathf
var pathf2
var pathf3
var pathf4
var pathf5
var follow_path_to_2
var follow_path_to_3
var follow_path_to_4
var follow_path_to_5


var all_vertexes
var aristas = []
func _ready() -> void:	
	changeWallsColor()	
	var vertexes = getVertexes()
	#add vertex sprite
	for obstacle in vertexes:
		for vertex in obstacle:
			var sprite = Sprite2D.new()
			sprite.texture = load(graph_node_image_path)
			sprite.position = vertex
			sprite.scale = Vector2(0.5,0.5)
			$'.'.add_child(sprite)
	#found all obstacle vertexes
	all_vertexes = []
	var walls = []	
	walls.append_array(getNodes("wall",1,4))
	walls.append_array(getNodes("wall",73,86))
	walls.append_array(getNodes("wall",87,99))
	walls.append_array(getNodes("wall",61,72))
	walls.append_array(getNodes("log",1,29))
	walls.append_array(getNodes("box",1,13))
	var vert = []
	for wall in walls:
		var found = vertexes(wall)
		var line1 = [found[3],found[2]]
		var line2 = [found[2],found[0]]
		var line3 = [found[1],found[0]]
		var line4 = [found[1],found[3]]
		all_vertexes.append(line1)
		all_vertexes.append(line2)
		all_vertexes.append(line3)
		all_vertexes.append(line4)
	
	g1 = Graph.new()
	var t = g1.visibilityGraphEasiest(all_vertexes,vertexes,$".")
	lados = t.size()
	var heur = Heuristic.new(g1.nodes[g1.nodes.size()-1])
	var fc = g1.pathfindAStar(g1,g1.nodes[0],g1.nodes[g1.nodes.size()-1],heur)
	
	target = get_node("Player")
	character = get_node("Character1")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	
	global_tile_pos = []
	for x in fc:
		var name = int(x.fromNode.name)
		if t[name][0] not in global_tile_pos:
			global_tile_pos.append(t[name][0])
	
	aristas.resize(global_tile_pos.size())
	aristas.fill([])
	for lado in t:
		var from = foundAt(lado[0])
		var to = foundAt(lado[1])
		if to not in aristas[from]:
			aristas[from].append(to)
	aristas=t
	
	
	var spikes = getAvailableNodes("spike",1,4)
	for spike in spikes:
		spike.play("new_animation")
	
	
	#disable arrows and collisions on all characters
	character.disableArrows()
	character.disableCollisions()
	character2.disableArrows()
	character2.disableCollisions()
	character3.disableArrows()
	character3.disableCollisions()
	character4.disableArrows()
	character4.disableCollisions()
	character5.disableArrows()
	character5.disableCollisions()
	target.disableArrows()
	target.disableCollisions()
	#layer for collisions
	layer = []
	layer.append_array(getNodes("wall",1,99))
	layer.append_array(getNodes("box",1,13))
	layer.append_array(getNodes("log",1,29))
	
	new = FollowPath.new(character,target,global_tile_pos)
	new2 = ObstacleAvoidance.new(character2,target,layer)
	obst = Flee.new(character2,target)
	arrive = Arrive.new(character2,target)
	seek = Seek.new(character2,target)
	
	wander2 = Seek.new(character3,target)
	evade = Flee.new(character3,target)
	arrive2 = Arrive.new(character3,target)
	
	seek2 = Seek.new(character4,target)
	arrive3 = Arrive.new(character4,target)
	
	character6 = get_node("Character6")
	character7 = get_node("Character7")
	character8 = get_node("Character8")
	character9 = get_node("Character9")
	character10 = get_node("Character10")
	character11 = get_node("Character11")
	character6.disableArrows()
	character6.disableCollisions()
	
	character7.disableArrows()
	character7.disableCollisions()
	
	character8.disableArrows()
	character8.disableCollisions()
	
	character9.disableArrows()
	character9.disableCollisions()
	character10.disableArrows()
	character10.disableCollisions()
	
	character11.disableArrows()
	character11.disableCollisions()
	
	follow = FollowPath.new(character8,target,global_tile_pos)
	
	follow9 = FollowPath.new(character9,target,global_tile_pos)
	
	follow10 = FollowPath.new(character10,target,global_tile_pos)
	
	follow11 = FollowPath.new(character11,target,global_tile_pos)
	seek11 = Seek.new(character11,target)
	arrive11 = Arrive.new(character11,target)
	
	wander5 = Wander.new(character5,character6)
	
	seek5 = Seek.new(character5,target)
	flee5 = Flee.new(character3,target)
	attack5 = Arrive.new(character5,target)
	
	seek6 = Seek.new(character6,target)
	attack6 = Arrive.new(character6,target)
	
	seek7 = Seek.new(character7,target)
	attack7 = Arrive.new(character7,target)	
	
	pathf = Sprite2D.new()
	pathf.texture = load(new_location_path)
	pathf.scale = Vector2(0.5,0.5)
	pathf.position = global_tile_pos[follow_path_to]
	add_child(pathf)
	
	follow_path_to_2 = closest_point_to(global_tile_pos,character8.position)
	follow_path_to_3 = closest_point_to(global_tile_pos,character9.position)
	follow_path_to_4 = closest_point_to(global_tile_pos,character10.position)
	follow_path_to_5 = closest_point_to(global_tile_pos,character11.position)
	
	pathf2 = Sprite2D.new()
	pathf2.texture = load(new_location_path)
	pathf2.scale = Vector2(0.5,0.5)
	pathf2.position = global_tile_pos[follow_path_to_2]
	add_child(pathf2)
	
	pathf3 = Sprite2D.new()
	pathf3.texture = load(new_location_path)
	pathf3.scale = Vector2(0.5,0.5)
	pathf3.position = global_tile_pos[follow_path_to_3]
	add_child(pathf3)
	
	pathf4 = Sprite2D.new()
	pathf4.texture = load(new_location_path)
	pathf4.scale = Vector2(0.5,0.5)
	pathf4.position = global_tile_pos[follow_path_to_4]
	add_child(pathf4)	
	
	pathf5 = Sprite2D.new()
	pathf5.texture = load(new_location_path)
	pathf5.scale = Vector2(0.5,0.5)
	pathf5.position = global_tile_pos[follow_path_to_5]
	add_child(pathf5)	
	
	old_modulation = character.modulate
	#point,restore,bonus
	var points = getNodes("point",1,39)
	for point in points:
		point.play("move_coin")
	var restore = getNodes("restore",1,13)
	for restorer in restore:
		restorer.play("move_restorers")
	var bonus = getNodes("bonus",1,2)
	for b in bonus:
		b.play("move_bonus")
	var torches = getNodes("torch",1,14)
	for torch in torches:
		torch.play("move_torch")
		
	var statesColor = [WALK_COLOR,ATTACK_COLOR,EVADE_COLOR,FOLLOW_PATH_COLOR,FOLLOW_PLAYER_COLOR,THROW_COLOR,UPDATE_TARGET_COLOR,WANDER_COLOR,FLEE_COLOR,GUARD_COLOR]
	var decisionColor = [color1,color2,color3,color4,color5,color6,color7,color8,color9]
	$Label.changeColors(decisionColor,statesColor)


func pos():
	if $Character.position.x >= 100:
		#$Character.transform = Color.RED
		return true
	elif $Character.position.x < 100:
		#$Character.transform = Color.BLUE
		return false
var counting = 20

func detectCollisionPlayer():
	var detector = CollisionDetector.new(layer)
	var ray = target.velocity
	ray.normalized()
	ray *= 1
	var collision = detector.getCollision(target.position, ray)
	if collision.position != Vector2.ZERO:
		target.velocity = Vector2.ZERO
	
	var l = get_node("Chest1")
	var detector1= CollisionDetector.new([l])
	var col = detector1.getCollision2(target.position,ray)
	if col.position != Vector2.ZERO:
		l._open()
		won = true
		$open_chest.play()
	
	var ch = getNodes("Character",1,11)
	var detector2 = CollisionDetector.new(ch)
	var collision2 = detector2.getCollision2(target.position, ray)
	if collision2.position != Vector2.ZERO:
		
		if counting==20:
			$damage_sound.play()
			target.damaged()
			counting=0
		counting+=1
			
	var ch2 = getAvailableNodes("point",1,39)
	ch2.append_array(getAvailableNodes("bonus",1,2))
	ch2.append_array(getAvailableNodes("spike",1,4))
	ch2.append_array(getAvailableNodes("restore",1,13))
	var detector3 = CollisionDetector.new(ch2)
	var collision3 = detector3.getCollision3(target.position, ray)
	if collision3 != null:
		if "point" in collision3.name:
			$coin_sound.play()
			target.recover()			
			remove_child(collision3)
			if target.score > SCORE_TO_GET_TO_LAST_ROW:
				var spikes = getAvailableNodes("spike",1,4)
				for spike in spikes:
					remove_child(spike)
				var closed_spikes = getAvailableNodes("closedspike",1,4)
				for spike in closed_spikes:
					spike.visible = true
		if "restore" in collision3.name:
			target.recover(20)
			$restore_sound.play()
			remove_child(collision3)
		if "bonus" in collision3.name:
			target.recover(50)
			$bonus_sound.play()
			remove_child(collision3)
		if "spike" in collision3.name:
			$spike_sound.play()
			target.velocity = Vector2.ZERO
			
		
func detectCollisionCharacter(char):
	var detector = CollisionDetector.new(layer)
	var ray = char.velocity
	ray.normalized()
	ray *= 1
	var collision = detector.getCollision(char.position, ray)
	
	if collision.position != Vector2.ZERO:
		char.velocity = Vector2.ZERO
		char.steering.lineal = -char.steering.lineal
		
		
	var detector2 = CollisionDetector.new([get_node("Player")])
	var collision2 = detector2.getCollision2(char.position, ray)
	if collision2.position != Vector2.ZERO:
		pass #char.velocity = Vector2.ZERO
		
	return char.steering

func decision_1():
	var d1 = decision1(character2,target)
	var decision = d1.makeDecision()
	#print(decision)
	if decision!= GUARD:
		character2.time=0.1
	if decision == WALK:
		#print("seek")
		character2.modulate = WALK_COLOR
		character2.steering = seek.getSteering()
	elif decision == ATTACK:
		#print("arrive")
		character2.modulate = ATTACK_COLOR
		character2.steering = arrive.getSteering()
	elif decision==GUARD:		
		character2.modulate = GUARD_COLOR
		character2.velocity = Vector2.ZERO
		character2.time=0
	
	if old_modulate:
		character2.modulate = old_modulation
	if differentiate:
		character2.modulate = colors[1]
		
	character2.steering = detectCollisionCharacter(character2)
	
func decision_2():
	#walk evade attack
	var d1 = decision2(character3,target)
	var decision = d1.makeDecision()
	#print(decision)
	if decision != GUARD:
		character3.time = 0.1
	if decision == WALK:
		#print("wander")
		character3.modulate = WALK_COLOR
		character3.steering = wander2.getSteering()
	elif decision == ATTACK:
		character3.modulate = ATTACK_COLOR
		character3.steering = arrive2.getSteering()
	elif decision == EVADE:
		character3.modulate = EVADE_COLOR
		character3.steering = evade.getSteering()
	elif decision == GUARD:
		character3.modulate = GUARD_COLOR
		character3.velocity = Vector2.ZERO
		character3.time = 0
	
	if old_modulate:
		character3.modulate = old_modulation
	if differentiate:
		character3.modulate = colors[2]
	character3.steering = detectCollisionCharacter(character3)

func foundAt(element):
	for x in range(global_tile_pos.size()):
		if global_tile_pos[x] == element:
			return x
	return -1

var followed_path =[0]
func decision_3():
	var d1 = decision3(character,target)
	var decision = d1.makeDecision()
	#print(decision)
	if decision == FOLLOW_PATH:
		#print("follow")
		character.modulate = FOLLOW_PATH_COLOR
		character.steering = new.getSteeringPrediction2(global_tile_pos[follow_path_to])
		
	elif decision == FOLLOW_PLAYER:
		#print("follow player")
		character.modulate = FOLLOW_PLAYER_COLOR
		character.steering = new.getSteeringPrediction()
	elif decision == UPDATE_TARGET:
		#print("update target")
		character.modulate = UPDATE_TARGET_COLOR
		var rng = RandomNumberGenerator.new()
		var from = global_tile_pos[follow_path_to]
		var to = []
		for arista in aristas:
			if arista[0] == from:
				to.append(arista[1])
		var n = rng.randf_range(1, to.size()-1)
		var pos = foundAt(to[n])
		follow_path_to=pos
		character.steering = new.getSteeringPrediction2(global_tile_pos[follow_path_to])
	pathf.position = global_tile_pos[follow_path_to]
	if old_modulate:
		character.modulate = old_modulation
	if differentiate:
		character.modulate = colors[3]
	character.steering = detectCollisionCharacter(character)
		

func decision_8(char,path_to,fol,image,wait,hammer_list):
	var d1 = decision8(char,target)
	var decision = d1.makeDecision()
	#print(decision)
	if decision == FOLLOW_PATH:
		char.modulate = FOLLOW_PATH_COLOR
		char.steering = fol.getSteeringPrediction2(global_tile_pos[path_to])
	elif decision == THROW:
		char.modulate = THROW_COLOR
		if wait==30:
			hammer_list.append(char.throw(target.position, target.orientation))
			wait=0
		wait+=1
		char.steering = fol.getSteeringPrediction2(global_tile_pos[path_to])
	elif decision == UPDATE_TARGET:
		char.modulate = UPDATE_TARGET_COLOR
		var rng = RandomNumberGenerator.new()
		var from = global_tile_pos[path_to]
		var to = []
		for arista in aristas:
			if arista[0] == from:
				to.append(arista[1])
		var n = rng.randf_range(1, to.size()-1)
		var pos = foundAt(to[n])
		path_to=pos
		char.steering = fol.getSteeringPrediction2(global_tile_pos[path_to])
	image.position = global_tile_pos[path_to]
	if old_modulate:
		char.modulate = old_modulation
	if differentiate:
		char.modulate = colors[8]
	char.steering = detectCollisionCharacter(char)
	return [hammer_list,wait]
	

func decision_9():
	var machine = decision9(character11,target)
	var s = machine.update()
	var priority = 1000
	var found = null
	for x in s:
		if x.priority < priority:
			priority = x.priority
			found = x
	var decision = found.value
	#print(decision)
	if decision == FOLLOW_PATH:
		character11.modulate = FOLLOW_PATH_COLOR
		character11.steering = follow11.getSteeringPrediction2(global_tile_pos[follow_path_to_5])
	elif decision == UPDATE_TARGET:
		character11.modulate = UPDATE_TARGET_COLOR
		var rng = RandomNumberGenerator.new()
		var from = global_tile_pos[follow_path_to_5]
		var to = []
		for arista in aristas:
			if arista[0] == from:
				to.append(arista[1])
		var n = rng.randf_range(1, to.size()-1)
		var pos = foundAt(to[n])
		follow_path_to_5=pos
		character11.steering = follow11.getSteeringPrediction2(global_tile_pos[follow_path_to_5])
	elif decision == ATTACK:
		character11.modulate = ATTACK_COLOR
		character11.steering = arrive11.getSteering()
		follow_path_to_5 = closest_point_to(global_tile_pos,character11.position)
	elif decision == WALK:
		character11.modulate = WALK_COLOR
		character11.steering = seek11.getSteering()
		follow_path_to_5 = closest_point_to(global_tile_pos,character11.position)
	pathf5.position = global_tile_pos[follow_path_to_5]
	if old_modulate:
		character11.modulate = old_modulation
	if differentiate:
		character11.modulate = colors[9]
	character11.steering = detectCollisionCharacter(character11)

var waiting = 0
var hammers = []
func decision_4():
	#prowl, attack, throw
	var d1 = decision4(character4,target)
	var decision = d1.makeDecision()
	#decision=THROW
	if decision != GUARD:
		character4.time=0.1
	if decision == ATTACK:
		character4.modulate = ATTACK_COLOR
		character4.steering = arrive3.getSteering()
	elif decision == GUARD:
		character4.modulate = GUARD_COLOR
		character4.velocity = Vector2.ZERO
		character4.time=0
	elif decision == THROW:
		#print("throw")
		character4.modulate = THROW_COLOR
		character4.steering = arrive3.getSteering()
		waiting+=1
		if waiting==30:
			hammers.append(character4.throw(target.position, target.orientation))
			waiting=0
	if old_modulate:
		character4.modulate = old_modulation
	if differentiate:
		character4.modulate = colors[4]
	character4.steering = detectCollisionCharacter(character4)


func decision_5():
	var machine = create_state_machine1(character5,target,character6)
	var s = machine.update()
	var priority = 1000
	var found = null
	for x in s:
		if x.priority < priority:
			priority = x.priority
			found = x
	var decision = found.value
	#print(decision)
	if decision != GUARD:
		character5.time = 0.1
	if decision == WANDER:
		character5.modulate = WANDER_COLOR
		character5.steering = wander5.getSteering2()
	elif decision == GUARD:
		character5.modulate = GUARD_COLOR
		character5.time = 0
		character5.velocity = Vector2.ZERO
	elif decision == WALK:
		character5.modulate = WALK_COLOR
		character5.steering = seek5.getSteering()
	elif decision == FLEE:
		character5.modulate = FLEE_COLOR
		character5.steering = flee5.getSteering()
	elif decision == ATTACK:
		character5.modulate = ATTACK_COLOR
		character5.steering = attack5.getSteering()
	if old_modulate:
		character5.modulate = old_modulation
	if differentiate:
		character5.modulate = colors[5]
	character5.steering = detectCollisionCharacter(character5)
	
func decision_6():
	var machine = create_state_machine2(character6,target)
	var s = machine.update()
	var priority = 1000
	var found = null
	for x in s:
		if x.priority < priority:
			priority = x.priority
			found = x
		
	var decision = found.value
	#print(decision)
	if decision != GUARD:
		character6.time = 0.1
	if decision == GUARD:
		character6.modulate = GUARD_COLOR
		character6.velocity = Vector2.ZERO
		character6.time = 0
	elif decision == WALK:
		character6.modulate = WALK_COLOR
		character6.steering = seek6.getSteering()
	elif decision == ATTACK:
		character6.modulate = ATTACK_COLOR
		character6.steering = attack6.getSteering()
	if old_modulate:
		character6.modulate = old_modulation
	if differentiate:
		character6.modulate = colors[6]
	character6.steering = detectCollisionCharacter(character6)
	
var waiting2 = 0
var hammers2 = []
func decision_7():
	var machine = create_state_machine3(character7,target)
	var s = machine.update()
	var priority = 1000
	var found = null
	for x in s:
		if x.priority < priority:
			priority = x.priority
			found = x
	var decision = found.value
	#print(decision)
	if decision!=GUARD:
		character7.time = 0.1
	
	if decision == GUARD:
		character7.modulate = GUARD_COLOR
		character7.velocity = Vector2.ZERO
		character7.time = 0
	elif decision == WALK:
		character7.modulate = WALK_COLOR
		character7.steering = seek7.getSteering()
	elif decision == ATTACK:
		character7.modulate = ATTACK_COLOR
		character7.steering = attack7.getSteering()
	elif decision == THROW:
		character7.modulate = THROW_COLOR
		character7.steering = attack7.getSteering()
		waiting2+=1
		if waiting2==30:
			hammers2.append(character7.throw(target.position, target.orientation))
			waiting2=0
	if old_modulate:
		character7.modulate = old_modulation
	if differentiate:
		character7.modulate = colors[7]
	character7.steering = detectCollisionCharacter(character7)
	
	
func create_state_machine1(char,player,char2):	
	var a1 = MachineAction.new(WANDER,2)
	var a2 = MachineAction.new(WALK,2)
	var a3 = MachineAction.new(FLEE,2)
	var a4 = MachineAction.new(ATTACK,1)
	
	var a5 = MachineAction.new(GUARD,2)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a3)
	
	var s4 = State.new(a4,a4,a3)
	
	var s5 = State.new(a5,a5,a1)
		
	#actions,targetState,condition
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(WANDER,2),s2,cond1)
	
	
	var condition2 = FloatCondition.new(200,player.position.distance_to(char.position),100000)
	var t2 = Transition.new(MachineAction.new(WALK,2),s3,condition2)
	
	var condition3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var t3 = Transition.new(MachineAction.new(FLEE,2),s2,condition3)
	
	var cond3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var cond4 = FloatCondition.new(0,player.currentHealth,50)
	var condition4 = AndCondition.new(cond3,cond4)
	var conditionnew = AndCondition.new(condition4,cond1)
	var t4 = Transition.new(MachineAction.new(ATTACK,1),s4,conditionnew)
	
	var condition5 = FloatCondition.new(50,player.currentHealth,100)
	var t5 = Transition.new(MachineAction.new(WALK,2),s2,condition5)
	
	var condition6 = FloatCondition.new(0,char2.position.distance_to(char.position),110)
	var t6 = Transition.new(MachineAction.new(GUARD,2),s1,condition6)
	
	
	s1.setTransitions([t1,t4])
	s2.setTransitions([t2,t4])
	s3.setTransitions([t3,t4])
	s4.setTransitions([t5])	
	s5.setTransitions([t6,t4])
	
	var machine = StateMachine.new(s5)
	return machine
	

func create_state_machine2(char,player):	
	var a1 = MachineAction.new(GUARD,2)
	var a2 = MachineAction.new(WALK,2)
	var a3 = MachineAction.new(ATTACK,1)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a2)
	
	
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(GUARD,2),s2,cond1)
	
	var condition2 = FloatCondition.new(200,player.position.distance_to(char.position),15000)
	var t2 = Transition.new(MachineAction.new(WALK,2),s1,condition2)
	
	var cond3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var cond4 = FloatCondition.new(0,player.currentHealth,60)
	var condition3 = AndCondition.new(cond3,cond4)
	var t3 = Transition.new(MachineAction.new(ATTACK,1),s3,condition3)
	
	var condition4 = FloatCondition.new(60,player.currentHealth,100)
	var t4 = Transition.new(MachineAction.new(WALK,2),s2,condition4)
		
	
	s1.setTransitions([t1,t3])
	s2.setTransitions([t2,t3])
	s3.setTransitions([t4])
	
	var machine = StateMachine.new(s1)
	return machine
	
	

func create_state_machine3(char,player):	
	var a1 = MachineAction.new(GUARD,2)
	var a2 = MachineAction.new(ATTACK,2)
	var a3 = MachineAction.new(WALK,2)
	var a4 = MachineAction.new(THROW,1)
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a4)
	
	var s4 = State.new(a4,a3,a1)
	
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(WALK,2),s2,cond1)
	
	var condition2 = FloatCondition.new(100,player.position.distance_to(char.position),150000)
	var con2 = AndCondition.new(condition2,NotCondition.new(cond1))
	var t2 = Transition.new(MachineAction.new(ATTACK,2),s3,con2)
	
	var condition3 = FloatCondition.new(0,player.currentHealth,70)
	var condition = AndCondition.new(cond1,condition3)
	var t3 = Transition.new(MachineAction.new(THROW,1),s4,condition)

	var condition4 = FloatCondition.new(70,player.currentHealth,100)
	var t4 = Transition.new(MachineAction.new(WALK,2),s1,condition4)	
	
	s1.setTransitions([t1,t3])
	s2.setTransitions([t2,t3])
	s3.setTransitions([t3])
	s4.setTransitions([t4])	
	
	var machine = StateMachine.new(s1)
	return machine
	
	


func simplemachine(char,player):	
	var a1 = MachineAction.new(GUARD,2)
	var a2 = MachineAction.new(WALK,2)
	var a3 = MachineAction.new(ATTACK,1)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a3)
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(GUARD,2),s2,cond1)
	
	var condition2 = Condition.new()
	condition2.condition = not player_is_visible(char,player)
	var t2 = Transition.new(MachineAction.new(WALK,2),s1,condition2)
	
	var cond2 = Condition.new()
	cond2.condition = player_is_visible(char,player)
	var condition3 = FloatCondition.new(0,player.position.distance_to(char.position),50)
	var condd = AndCondition.new(cond2,condition3)
	var t3 = Transition.new(MachineAction.new(ATTACK,1),s3,condd)
	
	s1.setTransitions([t1,t3])
	s2.setTransitions([t3])
	s3.setTransitions([])
	
	var machine = StateMachine.new(s1)
	return machine
	
	

func is_visible_from(p1,p2):
	var line1 = p2-p1
	var lines = all_vertexes
	var visible = true
	for line2 in lines:
		if line2[1] == p1 and line2[0] == p2 or line2[0]==p1 and line2[1]==p2:
			continue
		if Geometry2D.segment_intersects_segment(line2[1],line2[0],p1,p2) == null:
			visible = visible and true
		elif Geometry2D.segment_intersects_segment(line2[0],line2[1],p1,p2) == null:
			visible = visible and true
		elif Geometry2D.segment_intersects_segment(line2[1],line2[0],p2,p1) == null:
			visible = visible and true
		elif Geometry2D.segment_intersects_segment(line2[0],line2[1],p2,p1) == null:
			visible = visible and true
		else:
			visible = visible and false
	return visible

func check_hammer_collision(hammer_list,character):
	if hammer_list.size()>1:
		for hammer in hammer_list:
			var col = character.detectCollisionCharacter(hammer,[get_node("Player")])
			if col[0]:
				character.remove_child(hammer)
				target.damaged()

func game_over():
	if target.currentHealth == -1:
		return true
	if target.currentHealth == 0:
		target.velocity = Vector2.ZERO
		$game_over_sound.play()
		target.currentHealth = -1
		return true
	else:
		return false
		

var wait = 0
var wait2=0
var wait3=0
var hammers3 = []
var hammers4 =[]
var hammers5=[]
var won = false
func _process(delta: float) -> void:
	if won:
		await $Chest1/AnimatedSprite2D.animation_looped
		$smoke.visible = true
		$smoke.play("move")
		await $open_chest.finished
		await $smoke.animation_looped
		
		if get_tree() != null:
			get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	elif game_over():
		$Player/menu.visible = true
	else:		
		detectCollisionPlayer()
		decision_1()
		decision_2()
		decision_3()
		decision_4()
		decision_5()
		decision_6()
		decision_7()		
		var b = decision_8(character8,follow_path_to_2,follow,pathf2,wait,hammers3)
		hammers3 = b[0]
		wait = b[1]
		var c  = decision_8(character9,follow_path_to_3,follow9,pathf3,wait2,hammers4)
		hammers4 = c[0]
		wait2 = c[1]
		var a = decision_8(character10,follow_path_to_4,follow10,pathf4,wait3,hammers5)
		hammers5 = a[0]
		wait3 = a[1]
		decision_9()
		
		
		if Input.is_action_just_pressed("enter"):
			var children = get_children(true)
			for child in children:
				if child is Line2D:
					child.visible = not child.visible
				elif child is Sprite2D:
					if child.texture.resource_path == graph_node_image_path:
						child.visible = not child.visible
			pathf.visible = not pathf.visible
			pathf2.visible = not pathf2.visible
			pathf3.visible = not pathf3.visible
			pathf4.visible = not pathf4.visible
		elif Input.is_action_just_pressed("space"):
			old_modulate = not old_modulate
		elif Input.is_action_just_pressed("labels"):
			$Label.visible = not $Label.visible
		elif Input.is_action_just_pressed("differentiate_characters"):
			differentiate = not differentiate
		check_hammer_collision(hammers,character4)
		check_hammer_collision(hammers2,character7)
		check_hammer_collision(hammers3,character8)
		check_hammer_collision(hammers4,character9)
		check_hammer_collision(hammers5,character10)
		
		
		
