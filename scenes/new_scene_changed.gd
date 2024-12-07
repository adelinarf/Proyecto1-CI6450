extends Node2D

var V
var new
var new2
var character
var character2
var character3
var g1
var follow
var follow9
var follow10
var follow11
var seek11
var arrive11
var wander5

var lados
var global_tile_pos = []
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
const END_PATH = "end_path"
const VISIBILITY = "visibility"
const COVER = "cover"
const SNIPER = "sniper"

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
const COVER_COLOR = Color.LIGHT_GREEN
const VISIBILITY_COLOR = Color.DARK_SLATE_BLUE
const SNIPER_COLOR = Color.FUCHSIA

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
var follow_path_to = 0

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
	
func mapping_to_ordered(f : Array,from, to) -> Array:
	var a = [-1,-1]
	for x in range(f.size()):
		if x == 0:
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if from_ == from:
				a.append(from_)
				a.append(to_)
			else:
				a.append(to_)
				a.append(from_)
		elif x == f.size():
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if from_ == to:
				a.append(from_)
				a.append(to_)
				
			else:
				a.append(to_)
				a.append(from_)
		else:
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if to_ not in a:
				a.append(to_)
			if from_ not in a:
				a.append(from_)
	var s = []
	for x in range(a.size()-1,2,-1):
		s.append(int(a[x]))
	return s
			

func mapping_to_ordered_vector(f : Array,from, to) -> Array:
	var a = [-1,-1]
	for x in range(f.size()):
		if x == 0:
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if from_ == from:
				a.append(f[x].fromNode.vector)
				a.append(f[x].toNode.vector)
			else:
				a.append(f[x].toNode.vector)
				a.append(f[x].fromNode.vector)
		elif x == f.size():
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if from_ == to:
				a.append(f[x].fromNode.vector)
				a.append(f[x].toNode.vector)
				
			else:
				a.append(f[x].toNode.vector)
				a.append(f[x].fromNode.vector)
		else:
			var from_ = f[x].fromNode.name
			var to_ = f[x].toNode.name
			if f[x].toNode.vector not in a:
				a.append(f[x].toNode.vector)
			if f[x].fromNode.vector not in a:
				a.append(f[x].fromNode.vector)
	var s = []
	for x in range(a.size()-1,2,-1):
		s.append(a[x])
	return s
	



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
var attack2
var seekc2

func findVertexes(name, array,constant):
	var nodes = getNodesByNumber(name,array)
	var found = []
	for node in nodes:
		found.append_array(vertexes_offset_pos(node,constant))
	return found

func getVertexes():
	var vertex = []
	
	var left_up_down = [61,83,  369]
	var right_up_down = [409,357]
	var right_down = [95,86,  93]
	var down = [72,65,4,97,   351,360,362,364,366,368,420,461, 63]
	var right_up = [69,74,   463]
	var left_up = [73,471,  362, 364, 366, 368]
	var left_down = [75,84,85,99,96,77,  94, 69]
	var up = [1,  355,417,457,347]
	
	var vertex1 = findVertexes("wall",left_up_down,"LEFT_UP_DOWN")
	var vertex2 = findVertexes("wall",right_up_down,"RIGHT_UP_DOWN")
	var vertex3 = findVertexes("wall",right_down,"RIGHT_DOWN")
	var vertex4 = findVertexes("wall",down,"DOWN")
	var vertex5 = findVertexes("wall",right_up,"RIGHT_UP")
	var vertex6 = findVertexes("wall",left_up,"LEFT_UP")
	var vertex7 = findVertexes("wall",left_down,"LEFT_DOWN")
	var vertex8 = findVertexes("wall",up,"UP")
	
	#faltan los logs
	var nodes = getNodesByNumber("log",[29])
	var found = []
	for node in nodes:
		found.append_array(vertexes_offset_pos(node))
	var vertex9 = findVertexes("log",[29],"ALL")
	
	var nodes2 = getNodesByNumber("log",[4])
	var found2 = []
	for node in nodes2:
		found2.append_array(vertexes_offset_pos(node,"RIGHT_UP_DOWN"))
	var vertex10 = findVertexes("log",[4],"RIGHT_UP_DOWN")
	var vertex11 = findVertexes("box",[2],"LEFT_DOWN")
	var vertex12 = findVertexes("log",[23],"DOWN")
	vertex.append_array([vertex1,vertex2,vertex3,vertex4,vertex5,vertex6,vertex7,vertex8,vertex9,vertex10,vertex11,vertex12])
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

var pathfollowing
var pathfollowing3
var _tile_pos = []

var all_vertexes
var aristas = []
var t
var fc
var path_set


var cover_node = [Vector2(1352,64),Vector2(1608,72),Vector2(1864,80),Vector2(2120,80),Vector2(2360,72),Vector2(920,704),Vector2(724,240),Vector2(216,236),Vector2(768,906),Vector2(664,808),Vector2(-32,1040)]
var visibility_node = [Vector2(360,451),Vector2(1360,411),Vector2(1064,1128)]
var sniper_node = [Vector2(1578,728),Vector2(2080,736),Vector2(2368,736)]
var terrain_node = [Vector2(1568,264),Vector2(1872,264),Vector2(2128,264)]
var beneficial_terrain_node = []


func create_nodes():
	var cover_image = "res://sprites/background/decoration/16.png"
	var vis_image = "res://sprites/background/decoration/13.png"
	var sniper_image = "res://sprites/enemies/hammer_.png"
	var terrain_image = "res://sprites/background/torch_4.png"
	for node in cover_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(cover_image)
		sprite.position = node
		add_child(sprite)
	for node in visibility_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(vis_image)
		sprite.position = node
		add_child(sprite)
	for node in sniper_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(sniper_image)
		sprite.position = node
		add_child(sprite)
	for node in terrain_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(terrain_image)
		sprite.position = node
		add_child(sprite) 

func _ready() -> void:	
	create_nodes()
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
	#nuevas
	'''"all_vertexes""all_vertexes"   
	344,369
	451,464
	397,423
	
	'''
	walls.append_array(getNodes("wall",344,357))
	walls.append_array(getNodes("wall",359,369))
	walls.append_array(getNodes("wall",451,471))
	walls.append_array(getNodes("wall",397,423))
	
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
	t = g1.visibilityGraphEasiest(all_vertexes,vertexes,$".")
	print(t.size())
	lados = t.size()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://sprites/cute_apple_still.png")
	sprite.position = g1.nodes[0].vector
	add_child(sprite)
	
	var sprite2 = Sprite2D.new()
	sprite2.texture = load("res://sprites/background/decoration/07.png")
	sprite2.position = g1.nodes[g1.nodes.size()-1].vector
	add_child(sprite2)
	
	var heur = Heuristic.new(g1.nodes[g1.nodes.size()-1])
	fc = g1.pathfindAStar(g1,g1.nodes[0],g1.nodes[g1.nodes.size()-1],heur,$".")
	#print(fc)
	print(mapping(fc))
	path_set = mapping_to_ordered(fc,g1.nodes[0].name,g1.nodes[g1.nodes.size()-1].name)
	
	print(path_set)
	global_tile_pos = mapping_to_ordered_vector(fc,g1.nodes[0].name,g1.nodes[g1.nodes.size()-1].name)
	
	target = get_node("Player")
	character = get_node("Character1")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	character6 = get_node("Character6")
	character7 = get_node("Character7")
	
	for x in fc:
		var name = int(x.fromNode.name)
		if t[name][0] not in global_tile_pos:
			pass #global_tile_pos.append(t[name][0])
	
	aristas.resize(global_tile_pos.size())
	aristas.fill([])
	for lado in t:
		#print(lado,"lado")
		var from = foundAt(lado[0])
		var to = foundAt(lado[1])
		#print(from,to,"from to")
		if from != -1 and to != -1:
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
	character6.disableArrows()
	character6.disableCollisions()
	character7.disableArrows()
	character7.disableCollisions()
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
	
	pathfollowing = FollowPath.new(character2,target,global_tile_pos)
	pathfollowing3 = FollowPath.new(character3,target,global_tile_pos)
	
	pathfollowing_char4 = FollowPath.new(character4,target,global_tile_pos)
	pathfollowing_char5 = FollowPath.new(character5,target,global_tile_pos)
	pathfollowing_char6 = FollowPath.new(character6,target,global_tile_pos)
	pathfollowing_char7 = FollowPath.new(character7,target,global_tile_pos)
	
	flee7 = Flee.new(character7,target)
	attack7 = Arrive.new(character7,target)
	seek7 = Seek.new(character7,target)
	
	pathf = Sprite2D.new()
	pathf.texture = load(new_location_path)
	pathf.scale = Vector2(0.5,0.5)
	#print(global_tile_pos[follow_path_to])
	#pathf.position = global_tile_pos[follow_path_to]
	add_child(pathf)
	
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
	
	
	#this_new()
	#this_new2()
	print("THIS IS THE 3RD")
	terrain_node = []
	#184,373 y 
	#1280, 2312 x
	#ponerlo mas a la izquierda
	for x in g1.nodes:
		if 953 <= x.vector.x and x.vector.x<=2500:
			if 184 <= x.vector.y and x.vector.y <=374:
				terrain_node.append(x.vector)
		if -104 <= x.vector.x and x.vector.x<=576:
			if 360 <= x.vector.y and x.vector.y <=574:
				beneficial_terrain_node.append(x.vector)
	#beneficial terrain nodes
	# desde x -104 576
	# desde y 360 574
	print(terrain_node.size(),"TAMANO DE TERRENO")
		
	visibility_node = change_node(visibility_node)
	cover_node = change_node(cover_node)
	sniper_node = change_node(sniper_node)

	this_new3()
	print("THIS IS THE 3RD")
	initialize_pathfinding(character4, pathfollowing_char4)
	points_char5[0] = g1.closest_to_node(points_char5[0])
	points_char5[1] = g1.closest_to_node(points_char5[1])
	points_char7[0] = g1.closest_to_node(points_char7[0])
	var s = Sprite2D.new()
	s.texture = load("res://sprites/background/pink_crystal_0003.png")
	s.position = points_char5[0].vector
	s.scale = Vector2(1,1)
	$'.'.add_child(s)
	var s2 = Sprite2D.new()
	s2.texture = load("res://sprites/background/pink_crystal_0003.png")
	s2.position = points_char5[1].vector
	s2.scale = Vector2(1,1)
	$'.'.add_child(s2)
	
	print("ESTE ES EL QUINTO")
	initialize_pathfinding(character5, pathfollowing_char5,true,[Color.RED,Color.WHITE],points_char5[0])
	print("ESTE ES EL QUINTO")
	initialize_pathfinding(character6, pathfollowing_char6)
	initialize_pathfinding(character7, pathfollowing_char7,true,[Color.RED,Color.WHITE],points_char7[0])

var colors_char1 = [Color.RED,Color.WHITE]
var colors_char2 = [Color.RED,Color.WHITE]
var colors_char3 = [Color.RED,Color.WHITE]
var colors_char4 = [Color.RED,Color.WHITE]
var colors_char5 = [Color.RED,Color.WHITE]



func change_node(nodes):
	var v = []
	for x in nodes:
		v.append(g1.closest_to_node(x))
	return v

var character4
var pathfollowing_char4
var character5
var pathfollowing_char5
var character6
var pathfollowing_char6
var character7
var pathfollowing_char7
var flee7
var arrive7
var path_5 = []

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
	
	var ch = getNodes("Character",1,7)
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


func foundAt(element):
	for x in range(global_tile_pos.size()):
		if global_tile_pos[x] == element:
			return x
	return -1

func player_is_visible(character,player):
	if g1.visibleF(player.position,character.position,all_vertexes,$"."):
		return true
	else:
		return false

func character_arrived_to_target2(char,player,path):
	var pos
	
	if char.position.distance_to(path[poss]) < 80:
		return true
	else:
		return false

func character_arrived_to_target3(char,player,path):
	var pos
	
	if char.position.distance_to(path[path.size()-1]) < 80:
		return true
	else:
		return false
		
func decision_new2(character,player,path):
	var action3 = Action.new(FOLLOW_PATH)
	var action2 = Action.new(UPDATE_TARGET)
	var actionnew = Action.new("FINALIZA")
	var d4 = Decision.new(actionnew,action2,character_arrived_to_target3(character,player,path))
	var d2 = Decision.new(d4,action3,character_arrived_to_target2(character,player,path))
	
	var action8 = Action.new(GUARD)
	var action = Action.new(COVER)
	var d3 = Decision.new(d2,action8,player_is_visible(character,player))
	return d2
	
		
func decision_follow_path(character,player,path):
	var action3 = Action.new(FOLLOW_PATH)
	var action2 = Action.new(UPDATE_TARGET)
	var actionnew = Action.new(END_PATH)
	var d4 = Decision.new(actionnew,action2,character_arrived_to_target3(character,player,path))
	var d2 = Decision.new(d4,action3,character_arrived_to_target2(character,player,path))
	return d2

func character_arrived_to_target(char,player,path):
	var pos
	
	if char.position.distance_to(path[thisone]) < 70:
		return true
	else:
		return false
		
func decision_find(character,player,path):
	var action8 = Action.new(FOLLOW_PATH)
	var action = Action.new(UPDATE_TARGET)
	var d3 = Decision.new(action,action8,character_arrived_to_target(character,player,path))
	return d3

var get_to = Vector2(528,645)
func this_new():
	var sprite = Sprite2D.new()
	sprite.texture = load("res://sprites/cute_apple_run.png")
	sprite.position = get_to
	sprite.scale = Vector2(0.5,0.5)
	$'.'.add_child(sprite)
	var closest_node = g1.closest_to_node(character.position)
	var cover_point_node = g1.closest_to_node(get_to)
	var heur = Heuristic.new(cover_point_node)
	var pathfinding = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	path_to = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	for x in path_to:
		var s = Sprite2D.new()
		s.texture = load("res://sprites/background/decoration/14.png")
		s.position = x
		s.scale = Vector2(0.5,0.5)
		$'.'.add_child(s)
	
var path_to = []
var thisone = 0
var new_one = Vector2(172,912)
func decision_pathfinding():
	var d = decision_find(character,target,path_to)
	var decision = d.makeDecision()
	if decision == FOLLOW_PATH:
		character.modulate = FOLLOW_PATH_COLOR
		character.steering = new.getSteeringPrediction2(path_to[thisone])
	elif decision == UPDATE_TARGET:
		character.modulate = UPDATE_TARGET_COLOR
		#this_new()
		thisone+=1
		
		print("thisone",thisone)
		if thisone > path_to.size()-1:
			#se llega al final del camino
			#actualizar el get_to y llamar de nuevo a this_new
			print("final del camino")
			var old = get_to
			get_to = new_one
			new_one = old
			this_new()
			thisone = 0
		
		if path_to.size() != 0:
			var s = Sprite2D.new()
			s.texture = load("res://sprites/background/pink_crystal_0003.png")
			s.position = path_to[thisone]
			s.scale = Vector2(0.5,0.5)
			$'.'.add_child(s)
			character.steering = new.getSteeringPrediction2(path_to[thisone])
		

func this_new2():
	var cover_point_node = check_points(cover_node, COVER_TYPE, true)
	var closest_node = g1.closest_to_node(character2.position)
	var heur = Heuristic.new(cover_point_node)
	var tactic = Tactic.new()
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	path_to_cover = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	var s = Sprite2D.new()
	s.texture = load("res://sprites/background/Tree.png")
	s.position = cover_point_node.vector
	s.scale = Vector2(0.5,0.5)
	$'.'.add_child(s)
	pathfollowing.positions=path_to_cover

var path_to_cover = []
var poss = 0
var new_one_cover = Vector2(172,912)


func decision_go_cover(character,player):
	var guard = Action.new(GUARD)
	var cover = Action.new(COVER)
	var d3 = Decision.new(cover,guard,player_is_visible(character,player))
	return d3
	

func character_arrived_to_target4(char,player,path):
	var pos
	if path.size()>0:
		if char.position.distance_to(path[path.size()-1]) < 120:
			return true
		else:
			return false
	else:
		return false
	
func decision_go_cover_vis_(character,player,path):
	var guard = Action.new(GUARD)
	var cover = Action.new(COVER)
	var vis = Action.new("VISUAL")
	var sniper = Action.new("SNIPER")
	var d1 = Decision.new(cover,sniper,character_arrived_to_target4(character,player,path))
	var d2 = Decision.new(sniper,vis,character_arrived_to_target4(character,player,path))
	var d3 = Decision.new(vis,cover,character_arrived_to_target4(character,player,path))
	return d3
	
func initialize_values(nodes,type):
	var cover_point_node = check_points(nodes, type, true)
	var closest_node = g1.closest_to_node(character2.position)
	var heur = Heuristic.new(cover_point_node)
	var tactic = Tactic.new()
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	path_to_cover = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	#print(path_to_cover,"camino gg")
	#print(cover_point_node.vector,"final gg")
	pathfollowing.positions=path_to_cover
	pathfollowing.pos = 0
	print(path_to_cover," path to cvoer")
	

func initialize_tactical_points_vals(nodes,type, char, follow_instance):
	var cover_point_node = check_points(nodes, type, true)
	var closest_node = g1.closest_to_node(char.position)
	var heur = Heuristic.new(cover_point_node)
	var tactic = Tactic.new(cover_node,visibility_node,sniper_node,terrain_node,beneficial_terrain_node)
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	var path_list = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	follow_instance.positions=path_list
	follow_instance.pos = 0
	
func initialize_pathfinding(char, follow_instance, colores : bool = false, color_list : Array = [], startNode : NodeR = NodeR.new(Vector2.ZERO)):
	var cover_point_node = g1.random_node()
	if startNode.vector != Vector2.ZERO:
		cover_point_node = startNode
	
	var s = Sprite2D.new()
	s.texture = load("res://sprites/cute_apple_still.png")
	s.position = cover_point_node.vector
	s.scale = Vector2(1,1)
	s.modulate = Color.CHARTREUSE
	$'.'.add_child(s)
	
	var closest_node = g1.closest_to_node(char.position)
	
	var s2 = Sprite2D.new()
	s2.texture = load("res://sprites/cute_apple_still.png")
	s2.position = closest_node.vector
	s2.scale = Vector2(1,1)
	s2.modulate = Color.CHARTREUSE
	$'.'.add_child(s2)
	var heur = Heuristic.new(cover_point_node)
	#cover : Array = [], vis : Array = [], sniper : Array = [], terrain : Array = []
	var tactic = Tactic.new(cover_node,visibility_node,sniper_node,terrain_node,beneficial_terrain_node)
	var p = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	#print(closest_node.vector,cover_point_node.vector, "de a ")
	#print(pathfinding, "sol")
	
	var path_list = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	#print(path_list,"sol")
	var path_a_star = mapping_to_ordered_vector(p,closest_node.name,cover_point_node.name)
	#print(path_a_star, "sol2")
	path_list.append(cover_point_node.vector)
	path_a_star.append(cover_point_node.vector)
	follow_instance.positions=path_list
	follow_instance.pos = 0
	#append last node at the end of both lists
	
			
	if colores:
		var children = get_children(true)
		for child in children:
			if child is Line2D and (child.default_color == color_list[0] or child.default_color == color_list[1]):
				child.visible = not child.visible
		create_lines(path_list,color_list[0],8)
		create_lines(path_a_star,color_list[1],4)
	
	

func create_lines(path,COLOR,thickness):
	var posicion2=0
	for x in path:
		if posicion2+1<=path.size()-1:
			var line = Line2D.new()
			line.add_point(path[posicion2],0)
			line.add_point(path[posicion2+1],1)
			line.default_color = COLOR
			line.width = thickness
			$'.'.add_child(line)
			posicion2+=1
		var s1 = Sprite2D.new()
		s1.texture = load("res://sprites/background/decoration/10.png")
		s1.position = x
		s1.scale = Vector2(2,2)
		$".".add_child(s1)

func decision_path_cover(character,player,path):
	var guard = Action.new(GUARD)
	var cover = Action.new(COVER)
	var vis = Action.new("VISUAL")
	var pathfind = Action.new(FOLLOW_PATH)
	var sniper = Action.new("SNIPER")
	#var d1 = Decision.new(cover,sniper,character_arrived_to_target4(character,player,path))
	#var d2 = Decision.new(sniper,vis,character_arrived_to_target4(character,player,path))
	var d3 = Decision.new(cover,pathfind,player_is_visible(character,player))
	return d3

func player_health_less_than(player,value):
	if player.currentHealth < 50:
		return true
	else:
		return false

func decision_cover_pathfinding(character,player):
	var cover = Action.new(COVER)
	var pathfind = Action.new(FOLLOW_PATH)
	var d3 = Decision.new(cover,pathfind,player_health_less_than(player,50))
	return d3

func distance_less_than(X,char,player):
	if char.position.distance_to(player.position) > X:
		return false
	else:
		return true
		
func decision_sniper_pathfinding(character,player):
	var sniper = Action.new("SNIPER")
	var pathfind = Action.new(FOLLOW_PATH)
	var d3 = Decision.new(sniper,pathfind,distance_less_than(200,character,player))
	return d3

func decision_throw_pathfinding(character,player):
	var throw = Action.new(THROW)
	var pathfind = Action.new(FOLLOW_PATH)
	var d3 = Decision.new(throw,pathfind,distance_less_than(200,character,player))
	return d3	
	
func decision_visibility_pathfinding(character,player):
	var cover = Action.new(COVER)
	var vis = Action.new("VISIBILITY")
	var pathfind = Action.new(FOLLOW_PATH)
	var throw = Action.new(THROW)
	var d2 = Decision.new(throw,vis,player_is_visible(character,player))
	var d3 = Decision.new(d2,pathfind,player_health_less_than(player,50))
	return d3
	

#CONSIDERAR EL CASO CUANDO A STAR NO CONSIGUE UN CAMINO ENTRE LOS PUNTOS

func decisions_new(char,inst_follow,older_decision,number):
	var d1
	if number == 1:
		d1 = decision_cover_pathfinding(char,target)
	elif number == 2:
		d1 = decision_sniper_pathfinding(char,target)
	elif number == 3:
		d1 = decision_throw_pathfinding(char,target)
	elif number == 4:
		d1 = decision_visibility_pathfinding(char,target)
	#decision_cover_pathfinding(char,target)
	#decision_sniper_pathfinding(char,target)
	#decision_throw_pathfinding(char,target)
	#decision_visibility_pathfinding(char,target)

	var decision = d1.makeDecision()
	if decision == COVER:
		if older_decision != decision:
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = COVER_COLOR
	elif decision == "SNIPER":
		if older_decision != decision:
			initialize_tactical_points_vals(sniper_node,SNIPER_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = COVER_COLOR
	elif decision == "VISIBILITY":
		if older_decision != decision:
			initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = COVER_COLOR
	elif decision == FOLLOW_PATH:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow)
			older_decision = decision
		char.modulate = FOLLOW_PATH_COLOR
	elif decision == THROW:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow)
			older_decision = decision
		char.modulate = THROW_COLOR
	var following = inst_follow.walk_all()
	#print(inst_follow.positions)
	if inst_follow.positions.size() == 0:
		initialize_pathfinding(char, inst_follow)
	if following != null:
		char.time=0.1
		char.steering = following
	else:
		#print("TERMINO EL ",decision, " NUEVO")
		if decision == FOLLOW_PATH or decision == THROW:
			initialize_pathfinding(char, inst_follow)
		elif decision == COVER:
			print("LLEGA AL COVER POINT")
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow)
		elif decision == VISIBILITY:
			print("llega al visibility point")
			initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow)
		else:
			char.time=0
			char.velocity = Vector2.ZERO
	return older_decision
		#


var old = FOLLOW_PATH
var path_ = []
func decision_walk(char,inst_follow):
	var d1 = decision_path_cover(char,target,path_)
	var decision = d1.makeDecision()
	if decision == COVER:
		if old != decision:
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow)
			old = decision
		char.modulate = COVER_COLOR
	elif decision == FOLLOW_PATH:
		if old != decision:
			initialize_pathfinding(char, inst_follow)
			old = decision
		char.modulate = FOLLOW_PATH_COLOR
	var following = inst_follow.walk_all()
	#print("following mud", following)
	if following != null:
		char.time=0.1
		char.steering = following
	else:
		#print("TERMINO EL ",decision, " NUEVO")
		if decision == FOLLOW_PATH:
			initialize_pathfinding(char, inst_follow)
		elif decision == COVER:
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow)
		#char.velocity = Vector2.ZERO
		#char.time = 0.0

#cuando llega al final se devuelve al mismo del inicio
var points_char5 = [Vector2(2340,497), Vector2(1064,264)]
func decision_walk_same_path(char,inst_follow):
	var following = inst_follow.walk_all()
	if following != null:
		char.time=0.1
		char.steering = following
	else:
		if inst_follow.positions[inst_follow.positions.size()-1] == points_char5[0].vector:
			initialize_pathfinding(char, inst_follow,true,[],points_char5[1])
		else:
			initialize_pathfinding(char, inst_follow,true,[],points_char5[0])

var points_char7 = [Vector2(444,678)]
func decision_only_pathfinding(char,inst_follow):
	var following = inst_follow.walk_all()
	if inst_follow.positions.size() == 0:
		initialize_pathfinding(char, inst_follow)
	if following != null:
		char.time=0.1
		char.steering = following
	else:
		initialize_pathfinding(char, inst_follow,true,[Color.RED,Color.WHITE],NodeR.new(Vector2.ZERO))
			
		

var path_to_mud = []
func this_new3():
	print("MUD") 
	#184,373 y 
	#1280, 2312 x
	#Vector2(1360,373)
	#Vector2(1106,759)
	var cover_point_node = g1.closest_to_node(Vector2(2340,497))
	var closest_node = g1.closest_to_node(character3.position)
	var s = Sprite2D.new()
	s.texture = load("res://sprites/background/HappySheep_Idle.png")
	s.position = cover_point_node.vector
	s.scale = Vector2(0.5,0.5)
	$'.'.add_child(s)
	
	var heur = Heuristic.new(cover_point_node)
	var p = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	var tactic = Tactic.new([],[],[],terrain_node)
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	print("FINALIZA PARA EL TERCERO")
	
	print(pathfinding,"mud pathfinding")
	print(p, "mud a star")
	path_to_mud = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	var path_a_star = mapping_to_ordered_vector(p,closest_node.name,cover_point_node.name)
	print(closest_node.vector, "from mud")
	print(cover_point_node.vector, "to mud")
	path_to_mud.append(cover_point_node.vector)
	print(path_to_mud,"PATH TO MUD")
	pathfollowing3.positions=path_to_mud
	var posicion = 0
	for x in path_a_star:
		if posicion+1<path_a_star.size()-1:
			var line = Line2D.new()
			line.add_point(path_a_star[posicion],0)
			line.add_point(path_a_star[posicion+1],1)
			line.default_color = Color.PURPLE
			line.width = 6
			$'.'.add_child(line)
			posicion+=1
		
		var s1 = Sprite2D.new()
		s1.texture = load("res://sprites/background/decoration/10.png")
		s1.position = x
		s1.scale = Vector2(3,3)
		s1.modulate = Color.BLACK
		$'.'.add_child(s1)
	var t = []
	for x in terrain_node:
		t.append(g1.closest_to_node(x))
		
	#fill terrain will all nodes de ese lugar a ver
	var posicion2=0
	for x in path_to_mud:
		if posicion2+1<path_to_mud.size()-1:
			var line = Line2D.new()
			line.add_point(path_to_mud[posicion2],0)
			line.add_point(path_to_mud[posicion2+1],1)
			line.default_color = Color.YELLOW
			line.width = 4
			$'.'.add_child(line)
			posicion2+=1
		var s1 = Sprite2D.new()
		s1.texture = load("res://sprites/background/decoration/10.png")
		s1.position = x
		s1.scale = Vector2(2,2)
		
		for elem in t:
			if elem.vector == x:
				s1.modulate = Color.RED
			else:
				var s2 = Sprite2D.new()
				s2.texture = load("res://sprites/background/decoration/10.png")
				s2.position = elem.vector
				s2.modulate = Color.NAVY_BLUE
				
		$'.'.add_child(s1)
	#g1.printAllPaths(closest_node,cover_point_node)


func this_new3_(char):
	print("MUD") 
	#184,373 y 
	#1280, 2312 x
	#Vector2(1360,373)
	#Vector2(1106,759)
	var cover_point_node = g1.closest_to_node(Vector2(2340,497))
	var closest_node = g1.closest_to_node(char.position)
	var s = Sprite2D.new()
	s.texture = load("res://sprites/background/HappySheep_Idle.png")
	s.position = cover_point_node.vector
	s.scale = Vector2(0.5,0.5)
	$'.'.add_child(s)
	
	var heur = Heuristic.new(cover_point_node)
	var p = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	var tactic = Tactic.new([],[],[],terrain_node)
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	print("FINALIZA PARA EL TERCERO")
	
	print(pathfinding,"mud pathfinding")
	print(p, "mud a star")
	path_to_mud = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
	var path_a_star = mapping_to_ordered_vector(p,closest_node.name,cover_point_node.name)
	print(closest_node.vector, "from mud")
	print(cover_point_node.vector, "to mud")
	path_to_mud.append(cover_point_node.vector)
	print(path_to_mud,"PATH TO MUD")
	pathfollowing3.positions=path_to_mud
	var posicion = 0
	for x in path_a_star:
		if posicion+1<path_a_star.size()-1:
			var line = Line2D.new()
			line.add_point(path_a_star[posicion],0)
			line.add_point(path_a_star[posicion+1],1)
			line.default_color = Color.PURPLE
			line.width = 6
			$'.'.add_child(line)
			posicion+=1
		
		var s1 = Sprite2D.new()
		s1.texture = load("res://sprites/background/decoration/10.png")
		s1.position = x
		s1.scale = Vector2(3,3)
		s1.modulate = Color.BLACK
		$'.'.add_child(s1)
	var t = []
	for x in terrain_node:
		t.append(g1.closest_to_node(x))
		
	#fill terrain will all nodes de ese lugar a ver
	var posicion2=0
	for x in path_to_mud:
		if posicion2+1<path_to_mud.size()-1:
			var line = Line2D.new()
			line.add_point(path_to_mud[posicion2],0)
			line.add_point(path_to_mud[posicion2+1],1)
			line.default_color = Color.YELLOW
			line.width = 4
			$'.'.add_child(line)
			posicion2+=1
		var s1 = Sprite2D.new()
		s1.texture = load("res://sprites/background/decoration/10.png")
		s1.position = x
		s1.scale = Vector2(2,2)
		
		for elem in t:
			if elem.vector == x:
				s1.modulate = Color.RED
			else:
				var s2 = Sprite2D.new()
				s2.texture = load("res://sprites/background/decoration/10.png")
				s2.position = elem.vector
				s2.modulate = Color.NAVY_BLUE
				
		$'.'.add_child(s1)
				

#hacer otra decision del camino sobre mud
#poner pesos negativos en esos nodos
#ir de a a b y devolverse luego de b a a
func decision_walk_through_mud():
	var following = null# pathfollowing3.walk_all()
	#print("following mud", following)
	if following != null:
		character3.time=0.1
		character3.steering = following
	else:
		character3.velocity = Vector2.ZERO
		character3.time = 0.0



var old_decision = COVER
func decision_cover():
	var d1 = decision_go_cover_vis_(character2,target,path_to_cover)
	var decision = d1.makeDecision()
	#print(decision," GET DECISION")
	if decision == COVER:
		#this_new2() 
		if old_decision != decision:
			initialize_values(cover_node,COVER_TYPE)
			old_decision = decision
		#
		character2.modulate = COVER_COLOR
	elif decision == "VISUAL":
		if old_decision != decision:
			#print("inicializa los valores")
			initialize_values(visibility_node,VIS_TYPE)
			old_decision = decision
			#print(old_decision,"  decision vieja")
		character2.modulate = GUARD_COLOR
	elif decision == "SNIPER":
		if old_decision != decision:
			initialize_values(sniper_node,SNIPER_TYPE)
			old_decision = decision
		character2.modulate = ATTACK_COLOR
	var following = pathfollowing.walk_all()
	#print(pathfollowing.pos,"pos")
	#print(pathfollowing.positions,"POSITIONS")
	#print(following,"following null o no")
	#si se quiere seguir otro camino se debe poner pos=0 y se mete el camino sacado de a*
	if following != null:
		character2.time=0.1
		character2.steering = following
	else:
		#print(decision)
		#initialize_values(visibility_node,VIS_TYPE)
		#print(character_arrived_to_target4(character2,target,path_to_cover))
		#print(path_to_cover)
		character2.velocity = Vector2.ZERO
		character2.time=0
	
	

func decision_cover_OLD():
	var d1 = decision_go_cover(character2,target)
	var decision = d1.makeDecision()
	print(decision)
	if decision!=GUARD:
		character2.time=0.1
	if decision == GUARD:
		character2.modulate = GUARD_COLOR
		character2.velocity = Vector2.ZERO
		character2.time=0
	elif decision == COVER:
		#this_new2() 
		character2.modulate = COVER_COLOR
		var following = pathfollowing.walk_all()
		#si se quiere seguir otro camino se debe poner pos=0 y se mete el camino sacado de a*
		if following != null:
			character2.steering = following
		else:
			character2.velocity = Vector2.ZERO
			character2.time=0
		 

func decision_follow_path_to():
	var d1 = decision_follow_path(character2,target,path_to_cover)
	var decision = d1.makeDecision()
	if decision == FOLLOW_PATH:
		character2.time=0.1
		character2.modulate = FOLLOW_PATH_COLOR
		character2.steering = pathfollowing.getSteeringPrediction2(path_to_cover[poss])
	elif decision == UPDATE_TARGET:
		character2.modulate = UPDATE_TARGET_COLOR
		poss+=1
		if poss > path_to_cover.size()-1:
			character2.velocity = Vector2.ZERO
			character2.time=0
		character2.steering = pathfollowing.getSteeringPrediction2(path_to_cover[poss])
	elif decision == END_PATH:
		print("LLEGA")
		character2.velocity = Vector2.ZERO
		character2.time=0
	


func decision_cover2():
	var d1 = decision_follow_path(character2,target,path_to_cover)
	var decision = d1.makeDecision()
	print(decision,"decision")
	if decision != GUARD:
		character2.time=0.1
	if decision == ATTACK:
		character2.modulate = ATTACK_COLOR
		character2.steering = attack2.getSteering()
	elif decision == GUARD:
		#character2.time=0.1
		character2.modulate = GUARD_COLOR
		character2.velocity = Vector2.ZERO
		character2.time=0
		#character2.steering = seek.getSteering()
	elif decision == FOLLOW_PATH:
		character2.time=0.1
		#this_new2()
		character2.modulate = FOLLOW_PATH_COLOR
		character2.steering = pathfollowing.getSteeringPrediction2(path_to_cover[poss])
	elif decision == UPDATE_TARGET:
		character2.modulate = UPDATE_TARGET_COLOR
		#this_new()
		poss+=1
		
		#print("POSS",poss)
		#print(path_to_cover)
		if poss > path_to_cover.size()-1:
			character2.velocity = Vector2.ZERO
			character2.time=0
		
		character2.steering = pathfollowing.getSteeringPrediction2(path_to_cover[poss])
	elif decision == END_PATH:
		print("LLEGA")
		character2.velocity = Vector2.ZERO
		character2.time=0
		#if poss > path_to_cover.size()-1:
		#	character2.velocity = Vector2.ZERO
		#	character2.time=0
			
			
		
		
	elif decision == COVER:
		character2.time=0.1
		character2.modulate = COVER_COLOR
		
		var cover_point_node = check_cover_points()
		var closest_node = g1.closest_to_node(character2.position)
		var heur = Heuristic.new(cover_point_node)
		var tactic = Tactic.new()
		var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
		print(pathfinding)
		#if pathfinding.size() > 0:
			#var path_set_order = mapping_to_ordered(pathfinding,closest_node.name,cover_point_node.name)
			#print(path_set_order)
		_tile_pos = mapping_to_ordered_vector(pathfinding,closest_node.name,cover_point_node.name)
		print(_tile_pos)
		if _tile_pos.size() > 0:
			character2.steering = pathfollowing.getSteeringPrediction2(_tile_pos[1])
		#else:
		
		if character2.position.distance_to(_tile_pos[0]) < 20:
			character2.modulate = GUARD_COLOR
			character2.velocity = Vector2.ZERO
			character2.time=0
	
	#character2.steering = detectCollisionCharacter(character2)
		

const COVER_TYPE = "COVER"
const VIS_TYPE = "VISUAL"
const SNIPER_TYPE = "SNIPER"
const TERRAIN_TYPE = "TERRAIN"

func check_points(points, TYPE, MAX):
	var characterSize = Vector2(20,20)
	var nodes = [] #,g1.closest_to_node(Vector2(160,240)),g1.closest_to_node(Vector2(776,900))]
	#location viene de un cover que se tiene
	if TYPE == COVER_TYPE:
		nodes = cover_node
	elif TYPE == VIS_TYPE:
		nodes = visibility_node
	elif TYPE == SNIPER_TYPE:
		nodes = sniper_node
	elif TYPE == TERRAIN_TYPE:
		nodes = terrain_node
	
	var max
	if MAX:
		max = 0
	else:
		max = INF
	var biggercover = null
	for node in nodes:
		var s = Sprite2D.new()
		s.texture = load("res://sprites/background/green_crystal_0003.png")
		s.position = node.vector
		s.scale = Vector2(0.5,0.5)
		$'.'.add_child(s)
		var q = Quality.new()
		var quality = 0
		if TYPE == COVER_TYPE:
			quality = q.getCoverQuality(node.vector,10,characterSize,all_vertexes)
		elif TYPE == VIS_TYPE:
			quality = q.getVisibilityQuality(node.vector,10,characterSize,all_vertexes)
		elif TYPE == SNIPER_TYPE:
			quality = q.getSniperQuality(node.vector,10,characterSize,all_vertexes)
		elif TYPE == TERRAIN_TYPE:
			quality = q.getTerrainQuality(node.vector,10,characterSize,all_vertexes)
		if MAX:
			if quality > max:
				max = quality
				biggercover = node
		else:
			if quality < max:
				max = quality
				biggercover = node
	return biggercover
		


func check_cover_points():
	var characterSize = Vector2(20,20)
	var cover_nodes = [] #,g1.closest_to_node(Vector2(160,240)),g1.closest_to_node(Vector2(776,900))]
	#location viene de un cover que se tiene
	for x in cover_node:
		cover_nodes.append(g1.closest_to_node(x))
	
	var min = 0
	var biggercover = null
	for node in cover_nodes:
		var s = Sprite2D.new()
		s.texture = load("res://sprites/background/green_crystal_0003.png")
		s.position = node.vector
		s.scale = Vector2(0.5,0.5)
		$'.'.add_child(s)
		var q = Quality.new()
		var quality = q.getCoverQuality(node.vector,10,characterSize,all_vertexes)
		print("quality",quality)
		#var vis = q.getVisibilityQuality(node.vector,10,characterSize,all_vertexes)
		#print("visibility",vis)
		if quality > min:
			min = quality
			biggercover = node
	#getCoverQuality(location, 10, characterSize,all_vertexes):
	return biggercover #g1.closest_to_node(Vector2(936,680))
		
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

### STATE MACHINES
func create_state_machine1(char,player):	
	var a1 = MachineAction.new(VISIBILITY,3)
	var a2 = MachineAction.new(WALK,2)
	var a3 = MachineAction.new(FLEE,2)
	var a4 = MachineAction.new(ATTACK,1)
	var a5 = MachineAction.new(FOLLOW_PATH,3)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a5,a4)
	
	var s3 = State.new(a3,a2,a2)
	
	var s4 = State.new(a4,a4,a5)
	
	var s5 = State.new(a5,a5,a1)
		
	#actions,targetState,condition
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var con2 = FloatCondition.new(200,player.position.distance_to(char.position),200000)
	var ff = FloatCondition.new(0,player.currentHealth,80)
	var con = AndCondition.new(cond1, ff)
	var t1 = Transition.new(MachineAction.new(WALK,2),s2,con)
	
	var condition2 = FloatCondition.new(200,player.position.distance_to(char.position),100000)
	var cond2 = AndCondition.new(con,condition2)
	var t2 = Transition.new(MachineAction.new(FLEE,2),s3,cond2)
	
	var condition3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var t3 = Transition.new(MachineAction.new(WALK,2),s2,condition3)
	
	var cond3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var cond4 = FloatCondition.new(0,player.currentHealth,50)
	var condition4 = AndCondition.new(cond3,cond4)
	var conditionnew = AndCondition.new(condition4,cond1)
	var t4 = Transition.new(MachineAction.new(ATTACK,1),s4,conditionnew)
	
	var condition5 = FloatCondition.new(50,player.currentHealth,100)
	var t5 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s5,condition5)
	
	var condition6 = NotCondition.new(cond1)
	var t6 = Transition.new(MachineAction.new(VISIBILITY,3),s1,condition6)
	
	
	s1.setTransitions([t4])
	s2.setTransitions([t4])
	#s3.setTransitions([t3,t4])
	s4.setTransitions([t5])	
	s5.setTransitions([t6,t4,t1])
	
	var machine = StateMachine.new(s5)
	return machine


func create_state_machine2(char,player):	
	var a1 = MachineAction.new(FOLLOW_PATH,3)
	var a2 = MachineAction.new(WALK,3)
	var a3 = MachineAction.new(ATTACK,1)
	var a4 = MachineAction.new(COVER,2)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a1)
	
	var s4 = State.new(a4,a1,a3)
	
	
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s2,cond1)
	
	var condition2 = FloatCondition.new(200,player.position.distance_to(char.position),15000)
	var t2 = Transition.new(MachineAction.new(WALK,3),s1,condition2)
	
	var cond3 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var cond4 = FloatCondition.new(0,player.currentHealth,60)
	var condition3 = AndCondition.new(cond3,cond4)
	var t3 = Transition.new(MachineAction.new(ATTACK,1),s3,condition3)
	
	var condition4 = FloatCondition.new(60,player.currentHealth,100)
	var t4 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,condition4)
	
	var cond5 = FloatCondition.new(0,char.currentHealth,80)
	var condition5 = AndCondition.new(cond1,cond5)
	var t5 = Transition.new(MachineAction.new(COVER,2),s4,condition5)
		
	
	s1.setTransitions([t1,t3,t5])
	s2.setTransitions([t2,t3])
	s3.setTransitions([t4])
	s4.setTransitions([t3])
	
	var machine = StateMachine.new(s1)
	return machine
	

func create_state_machine3(char,player):	
	var a1 = MachineAction.new(FOLLOW_PATH,3)
	var a2 = MachineAction.new(WALK,3)
	var a3 = MachineAction.new(ATTACK,2)
	var a4 = MachineAction.new(SNIPER,1)
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a4)
	
	var s4 = State.new(a4,a3,a1)
	
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(WALK,3),s2,cond1)
	
	var condition2 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var con2 = AndCondition.new(condition2,cond1)
	var cond = FloatCondition.new(0,player.currentHealth,90)
	var t2 = Transition.new(MachineAction.new(ATTACK,2),s3,con2)
	
	var condition3 = FloatCondition.new(0,player.currentHealth,70)
	var condition = AndCondition.new(NotCondition.new(cond1),condition3)
	var t3 = Transition.new(MachineAction.new(SNIPER,1),s4,condition3)

	var condition4 = FloatCondition.new(75,player.currentHealth,100)
	var t4 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,condition4)	
	
	s1.setTransitions([t1,t3,t2])
	s2.setTransitions([t3])
	s3.setTransitions([t3])
	s4.setTransitions([t4])	
	
	var machine = StateMachine.new(s1)
	return machine
	
func create_state_machine4(char,player):
	var a1 = MachineAction.new(FOLLOW_PATH,2)
	var a2 = MachineAction.new(THROW,2)
	var a3 = MachineAction.new(VISIBILITY,1)
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	var s2 = State.new(a2,a1,a3)
	var s3 = State.new(a3,a2,a1)
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(THROW,2),s2,cond1)
	
	var condition4 = FloatCondition.new(0,player.currentHealth,60)
	var t2 = Transition.new(MachineAction.new(VISIBILITY,1),s3,condition4)	
	
	var condition3 = FloatCondition.new(60,player.currentHealth,100)
	var t3 = Transition.new(MachineAction.new(FOLLOW_PATH,2),s1,condition3)	
	
	s1.setTransitions([t1,t2])
	s2.setTransitions([t2])
	s3.setTransitions([t3])
	var machine = StateMachine.new(s1)
	return machine
	
	
#MACHINE DECISIONS
func decision_5(char,older_decision,inst_follow,walk_char,flee_char,attack_char,TYPE):
	var machine
	if TYPE == 1:
		machine = create_state_machine1(char,target)
	elif TYPE ==2:
		machine = create_state_machine2(char,target)
	elif TYPE == 3:
		machine = create_state_machine3(char,target)
	elif TYPE == 4:
		machine = create_state_machine4(char,target)
		
	var s = machine.update()
	var priority = 1000
	var found = null
	for x in s:
		if x.priority < priority:
			priority = x.priority
			found = x
		print(x.value)
	var decision = found.value
	#print(decision)
	print(char.currentHealth,"HEALTH DEL ENEMIGO")
	if decision==ATTACK and target.position.distance_to(char.position)<=100:
		print(target.position.distance_to(char.position),"attack OSICION")
	
	#FOLLOW_PATH, VISIBILITY,    WALK,FLEE,ATTACK,
	print(decision,"DECISION")
	if decision == FOLLOW_PATH:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow)
			older_decision = decision
		char.modulate = FOLLOW_PATH_COLOR
	elif decision == THROW:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow)
			older_decision = decision
		char.modulate = THROW_COLOR
		waiting2+=1
		if waiting2==30:
			hammers2.append(char.throw(target.position, target.orientation))
			waiting2=0
	elif decision == VISIBILITY:
		if older_decision != decision:
			initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = VISIBILITY_COLOR
	elif decision == COVER:
		if older_decision != decision:
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = COVER_COLOR
	elif decision == SNIPER:
		if older_decision != decision:
			initialize_tactical_points_vals(sniper_node,SNIPER_TYPE, char, inst_follow)
			older_decision = decision
		char.modulate = SNIPER_COLOR
	elif decision == WALK:
		char.modulate = WALK_COLOR
		char.steering = walk_char.getSteering()
		older_decision = decision
	elif decision == FLEE:
		char.modulate = FLEE_COLOR
		char.steering = flee_char.getSteering()
		older_decision = decision
	elif decision == ATTACK:
		char.modulate = ATTACK_COLOR
		char.steering = attack_char.getSteering()
		older_decision = decision
		
	if decision==FOLLOW_PATH or decision==VISIBILITY or decision==COVER or decision==SNIPER:
		var following = inst_follow.walk_all()
		if inst_follow.positions.size() == 0:
			initialize_pathfinding(char, inst_follow)
		if following != null:
			char.time=0.1
			char.steering = following
		else:
			#print("TERMINO EL ",decision, " NUEVO")
			if decision == FOLLOW_PATH:
				initialize_pathfinding(char, inst_follow)
			elif decision == VISIBILITY:
				print("llega al visibility point")
				char.time = 0
				char.velocity = Vector2.ZERO
				#initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow)
			elif decision == COVER:
				char.time = 0
				char.velocity = Vector2.ZERO
			elif decision == SNIPER:
				char.time = 0
				char.velocity = Vector2.ZERO
				waiting2+=1
				if waiting2==30:
					hammers2.append(char.throw(target.position, target.orientation))
					waiting2=0
				#throw things
	return older_decision
var waiting2 = 0
var hammers2 = []


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
var older_decision6 = FOLLOW_PATH
var older_dec = FOLLOW_PATH
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
		#decision_pathfinding()
		#decision_cover()
		#decision_walk_through_mud()
		#decision_walk(character4,pathfollowing_char4)
		#decision_walk_same_path(character5,pathfollowing_char5)
		#older_decision6 = decisions_new(character6,pathfollowing_char6,older_decision6,4)
		
		#4 decisiones para la entrega
		#older_dec = decision_5(character7,older_dec,pathfollowing_char7,seek7,flee7,attack7,1)
		decision_only_pathfinding(character7,pathfollowing_char7)
		
		if Input.is_action_just_pressed("enter"):
			var children = get_children(true)
			for child in children:
				if child is Line2D:
					child.visible = not child.visible
				elif child is Sprite2D:
					if child.texture.resource_path == graph_node_image_path:
						child.visible = not child.visible
			#pathf.visible = not pathf.visible
			#pathf2.visible = not pathf2.visible
			#pathf3.visible = not pathf3.visible
			#pathf4.visible = not pathf4.visible
		elif Input.is_action_just_pressed("space"):
			old_modulate = not old_modulate
		elif Input.is_action_just_pressed("labels"):
			$Label.visible = not $Label.visible
		elif Input.is_action_just_pressed("differentiate_characters"):
			differentiate = not differentiate
		
