extends Node2D

var V
var new
var new2
var character
var character2
var character3
var character4
var character5
var layer
var pathfollowing_char1 
var flee1 
var attack1 
var seek1 

var pathfollowing_char2
var flee2
var attack2 
var seek2

var pathfollowing_char3
var flee3
var attack3 
var seek3

var pathfollowing_char4
var flee4
var attack4 
var seek4

var pathfollowing_char5
var flee5
var attack5 
var seek5

var pathfollowing_char6
var flee6
var attack6 
var seek6

var pathfollowing_char7
var flee7
var attack7 
var seek7

var g1

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
			
func mapping_to_ordered_vector(f : Array,from, to, COLOR, thickness,colores) -> Array:
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
	var posicion2=a.size()-1
	if colores and a.size() > 0:
		var children = get_children(true)
		for child in children:
			if child is Line2D and child.default_color == COLOR:
				remove_child(child)
	for x in range(a.size()-1,2,-1):
		s.append(a[x])
		if colores and a.size() > 0:
			if posicion2+1>=1:
				var line = Line2D.new()
				line.add_point(a[posicion2],0)
				line.add_point(a[posicion2-1],1)
				line.default_color = COLOR
				line.width = thickness
				if COLOR in selected_colors or selected_colors == []:
					line.visible = true
				else:
					line.visible = false
				$'.'.add_child(line)
				posicion2-=1
	return s

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
	var right_down = [86,  93]
	var down = [72,65,4,97,   351,360,362,364,366,368,420,461, 63]
	var right_up = [69,74,   463]
	var left_up = [73,471,  362, 364, 366, 368, 591]
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
	var nodes = getAvailableNodes("wall",1,690)
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
var cover_node_ = []
var visibility_node = [Vector2(360,451),Vector2(1360,411),Vector2(1064,1128)]
var visibility_node_ =[]
var sniper_node = [Vector2(1578,728),Vector2(2080,736),Vector2(2368,736)]
var sniper_node_ =[]
var terrain_node = [Vector2(1568,264),Vector2(1872,264),Vector2(2128,264)]
var terrain_node_ =[]
var benefitial_terrain_node = []
var benefitial_terrain_node_ =[]
var non_benefitial_terrain_node = []
var non_benefitial_terrain_node_ =[]

var cover_image = "res://sprites/background/tactical nodes/cover.png"
var vis_image = "res://sprites/background/tactical nodes/visibility.png"
var sniper_image = "res://sprites/background/tactical nodes/sniper.png"
var terrain_image = "res://sprites/background/tactical nodes/terrain_minus.png"
var terrain_benefitial_image = "res://sprites/background/tactical nodes/terrain_plus.png"
var terrain_non_benefitial_image = "res://sprites/background/tactical nodes/terrain_lose.png"


var cover_quality
var vis_quality
var sniper_quality

func create_nodes():
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
		sprite.scale = Vector2(3,3)
		add_child(sprite)
	for node in terrain_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(terrain_image)
		sprite.position = node
		add_child(sprite) 
	for node in benefitial_terrain_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(terrain_benefitial_image)
		sprite.position = node
		add_child(sprite)
	for node in non_benefitial_terrain_node:
		var sprite = Sprite2D.new()
		sprite.texture = load(terrain_non_benefitial_image)
		sprite.position = node
		add_child(sprite)

var tactic
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
	
	target = get_node("Player")
	character = get_node("Character1")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	
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
	
	#walls.append_array(getNodes("wall",344,357))
	#walls.append_array(getNodes("wall",359,369))
	#walls.append_array(getNodes("wall",451,471))
	#walls.append_array(getNodes("wall",397,423))
	layer.append_array(getAvailableNodes("wall",100,690))
	
	layer.append_array(getNodes("box",1,13))
	layer.append_array(getNodes("log",1,29))
		
	pathfollowing_char1 = FollowPath.new(character,target,global_tile_pos)
	flee1 = Flee.new(character,target)
	attack1 = Arrive.new(character,target)
	seek1 = Seek.new(character,target)
	
	pathfollowing_char2 = FollowPath.new(character2,target,global_tile_pos)
	flee2 = Flee.new(character2,target)
	attack2 = Arrive.new(character2,target)
	seek2 = Seek.new(character2,target)
	
	pathfollowing_char3 = FollowPath.new(character3,target,global_tile_pos)
	flee3 = Flee.new(character3,target)
	attack3 = Arrive.new(character3,target)
	seek3 = Seek.new(character3,target)
	
	pathfollowing_char4 = FollowPath.new(character4,target,global_tile_pos)
	flee4 = Flee.new(character4,target)
	attack4 = Arrive.new(character4,target)
	seek4 = Seek.new(character4,target)
	
	pathfollowing_char5 = FollowPath.new(character5,target,global_tile_pos)
	flee5 = Flee.new(character5,target)
	attack5 = Arrive.new(character5,target)
	seek5 = Seek.new(character5,target)

	
	old_modulation = character.modulate
	#point,restore,bonus
	var points = getNodes("point",1,40)
	for point in points:
		point.play("move_coin")
	var restore = getNodes("restore",1,13)
	for restorer in restore:
		restorer.play("move_restorers")
	var bonus = getNodes("bonus",1,2)
	for b in bonus:
		b.play("move_bonus")
	var torches = getNodes("torch",1,28)
	for torch in torches:
		torch.play("move_torch")
		
	#var statesColor = [WALK_COLOR,ATTACK_COLOR,EVADE_COLOR,FOLLOW_PATH_COLOR,FOLLOW_PLAYER_COLOR,THROW_COLOR,UPDATE_TARGET_COLOR,WANDER_COLOR,FLEE_COLOR,GUARD_COLOR]
	#var decisionColor = [color1,color2,color3,color4,color5,color6,color7,color8,color9]
	#$Label.changeColors(decisionColor,statesColor)
	var states_colors = [FOLLOW_PATH_COLOR,WALK_COLOR,ATTACK_COLOR,VISIBILITY_COLOR,COVER_COLOR,SNIPER_COLOR,THROW_COLOR]
	var states_text = ["Follow Path","Seek","Arrive","Visibility","Cover","Sniper","Throw"]
	var tactical = [[cover_image,"Cover"],[vis_image,"Visibility"],[sniper_image,"Sniper"],[terrain_benefitial_image,"Terrain +"],[terrain_image,"Terrain -"],[terrain_non_benefitial_image,"Terrain lose health"]]
	$Label.changeColorsSecond(decision_colors,states_colors,states_text,tactical)
	
	terrain_node = []
	#184,373 y 
	#1280, 2312 x
	#ponerlo mas a la izquierda
	var tactical_dictionary_weights = {}
	var tactical_dictionary_tactics = {}
	
	var terrain_weight = 200
	var benefitial_terrain_weight = -60
	var non_benefitial_terrain_weight = 200
	var cover_weight = -10
	var vis_weight = -20
	var sniper_weight = -1
	var terrain_tactic = 0.5
	var benefitial_terrain_tactic = 1
	var non_benefitial_terrain_tactic = 0.1
	var cover_tactic = -1
	var vis_tactic = -1
	var sniper_tactic = -1
	
	for x in g1.nodes:
		#if 953 <= x.vector.x and x.vector.x<=2500:
		#	if 184 <= x.vector.y and x.vector.y <=374:
		if terrain_nodes_pos["x_low"] <= x.vector.x and x.vector.x<=terrain_nodes_pos["x_top"]:
			if terrain_nodes_pos["y_low"] <= x.vector.y and x.vector.y <=terrain_nodes_pos["y_top"]:
				terrain_node_.append(x)
				terrain_node.append(x.vector)
				tactical_dictionary_weights[x.vector] = terrain_weight
				tactical_dictionary_tactics[x.vector] = terrain_tactic
		#if -104 <= x.vector.x and x.vector.x<=576:
		#	if 360 <= x.vector.y and x.vector.y <=574:
		if non_benefitial_terrain_nodes_pos["x_low"] <= x.vector.x and x.vector.x<=non_benefitial_terrain_nodes_pos["x_top"]:
			if non_benefitial_terrain_nodes_pos["y_low"] <= x.vector.y and x.vector.y <=non_benefitial_terrain_nodes_pos["y_top"]:
				non_benefitial_terrain_node_.append(x)
				non_benefitial_terrain_node.append(x.vector)
				tactical_dictionary_weights[x.vector] = non_benefitial_terrain_weight
				tactical_dictionary_tactics[x.vector] = non_benefitial_terrain_tactic
		#if -112 <= x.vector.x and x.vector.x<=1144:
		#if -8 <= x.vector.y and x.vector.y <=104:
		if benefitial_terrain_nodes_pos[0]["x_low"] <= x.vector.x and x.vector.x<=benefitial_terrain_nodes_pos[0]["x_top"]:
			if benefitial_terrain_nodes_pos[0]["y_low"] <= x.vector.y and x.vector.y <=benefitial_terrain_nodes_pos[0]["y_top"]:
				benefitial_terrain_node_.append(x)
				benefitial_terrain_node.append(x.vector)
				tactical_dictionary_weights[x.vector] = benefitial_terrain_weight
				tactical_dictionary_tactics[x.vector] = benefitial_terrain_tactic
		#if 1304 <= x.vector.x and x.vector.x<=2432:
		#if 668 <= x.vector.y and x.vector.y <=832:
		if benefitial_terrain_nodes_pos[1]["x_low"] <= x.vector.x and x.vector.x<=benefitial_terrain_nodes_pos[1]["x_top"]:
			if benefitial_terrain_nodes_pos[1]["y_low"] <= x.vector.y and x.vector.y <=benefitial_terrain_nodes_pos[1]["y_top"]:
				benefitial_terrain_node_.append(x)
				benefitial_terrain_node.append(x.vector)
				tactical_dictionary_weights[x.vector] = benefitial_terrain_weight
				tactical_dictionary_tactics[x.vector] = benefitial_terrain_tactic
	#non benefitial terrain nodes
	# desde x -104 576
	# desde y 360 574
	
	#benefitial terrain nodes
	# primero
	# desde x -112 1144 
	# desde y -8 104
	# segundo
	# desde x 1304 2432
	# desde y  668 832
		
	#vectors,node
	var res = change_node(visibility_node,tactical_dictionary_weights,tactical_dictionary_tactics,vis_weight,vis_tactic)
	visibility_node = res[0]
	visibility_node_ = res[1]
	tactical_dictionary_tactics = res[2]
	tactical_dictionary_weights = res[3]
	var res2 = change_node(cover_node,tactical_dictionary_weights,tactical_dictionary_tactics,cover_weight,cover_tactic)
	cover_node = res2[0]
	cover_node_ = res2[1]
	tactical_dictionary_tactics = res2[2]
	tactical_dictionary_weights = res2[3]
	var res3 = change_node(sniper_node,tactical_dictionary_weights,tactical_dictionary_tactics,sniper_weight,sniper_tactic)
	sniper_node = res3[0]
	sniper_node_ = res3[1]
	tactical_dictionary_tactics = res3[2]
	tactical_dictionary_weights = res3[3]
	
	tactic = Tactic.new(tactical_dictionary_weights,tactical_dictionary_tactics)
	
	create_nodes()
	
	cover_quality = quality_of_tactical_nodes(COVER_TYPE)
	vis_quality = quality_of_tactical_nodes(VIS_TYPE)
	sniper_quality = quality_of_tactical_nodes(SNIPER_TYPE)

	points_char7[0] = g1.closest_to_node(points_char7[0])
	if 1 in running:
		initialize_pathfinding(character, pathfollowing_char1,true,colors_char1)
	if 2 in running:
		initialize_pathfinding(character2, pathfollowing_char2,true,colors_char2)
	if 3 in running:
		initialize_pathfinding(character3, pathfollowing_char3,true,colors_char3)
	if 4 in running:
		initialize_pathfinding(character4, pathfollowing_char4,true,colors_char4)
	if 5 in running:
		initialize_pathfinding(character5, pathfollowing_char5,true,colors_char5,points_char7[0])
	
	
	
	var children = get_children(true)
	for child in children:
		if child is AudioStreamPlayer2D:
			child.volume_db = -200


var decision_colors = [Color.RED,Color.BLUE,Color.GREEN,Color.YELLOW,Color.WEB_PURPLE]

var colors_char1 = [Color.RED,Color.PALE_VIOLET_RED]
var colors_char2 = [Color.BLUE,Color.SKY_BLUE]
var colors_char3 = [Color.DARK_GREEN,Color.SPRING_GREEN]
var colors_char4 = [Color.YELLOW,Color.LIGHT_YELLOW]
var colors_char5 = [Color.PURPLE,Color.VIOLET]


var terrain_nodes_pos = {
	"x_low": 953,
	"x_top" : 2500,
	"y_low" : 184,
	"y_top" : 374 
		}
	
var non_benefitial_terrain_nodes_pos = {
"x_low": -104,
"x_top" : 576,
"y_low" : 360,
"y_top" : 574 
	}
var benefitial_terrain_nodes_pos = [{
"x_low": -112,
"x_top" : 1144,
"y_low" : -8,
"y_top" : 104 
	},{
"x_low": 1304,
"x_top" : 2432,
"y_low" : 668,
"y_top" : 832 
	}]


func change_node(nodes,weight_dict, tactic_dict, weight, tactic):
	var vectors = []
	var nod = []
	for x in nodes:
		var node = g1.closest_to_node(x)
		nod.append(node)
		vectors.append(node.vector)
		weight_dict[node.vector] = weight
		tactic_dict[node.vector] = tactic
	return [vectors,nod, tactic_dict, weight_dict]
	

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
	
	var ch = getNodes("Character",1,5)
	var detector2 = CollisionDetector.new(ch)
	var collision2 = detector2.getCollision2(target.position, ray)
	if collision2.position != Vector2.ZERO:
		
		if counting==20:
			$damage_sound.play()
			target.damaged()
			counting=0
		counting+=1
			
	var ch2 = getAvailableNodes("point",1,40)
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
		
func setPerpendicular(vec : Vector2, dir : float):
	var tempVec := vec
	vec.x = vec.y
	vec.y = tempVec.x
	if(dir != 0):
		vec.x *= -1
	else:
		vec.y *= -1
	return vec
		
func setDiagonal(vec : Vector2, dir : float):
	var perpVec = setPerpendicular(vec, dir)
	vec = (perpVec + vec) / 2.0
	vec = vec.normalized()
	return vec
	
func detectCollisionCharacter(char):
	var detector = CollisionDetector.new(layer)
	var ray = char.velocity
	ray.normalized()
	ray *= 3 
	var collision = detector.getCollision(char.position, ray)
	
	if collision.position != Vector2.ZERO:
		char.velocity = char.velocity.orthogonal()
		
	var detector2 = CollisionDetector.new([get_node("Player")])
	var collision2 = detector2.getCollision2(char.position, ray)
	if collision2.position != Vector2.ZERO:
		char.damage()
		
		
	if non_benefitial_terrain_nodes_pos["x_low"] <= char.position.x and char.position.x<=non_benefitial_terrain_nodes_pos["x_top"]:
		if non_benefitial_terrain_nodes_pos["y_low"] <= char.position.y and char.position.y <=non_benefitial_terrain_nodes_pos["y_top"]:
			char.damage()
	if benefitial_terrain_nodes_pos[0]["x_low"] <= char.position.x and char.position.x<=benefitial_terrain_nodes_pos[0]["x_top"]:
		if benefitial_terrain_nodes_pos[0]["y_low"] <= char.position.y and char.position.y <=benefitial_terrain_nodes_pos[0]["y_top"]:
			char.recover()
	if benefitial_terrain_nodes_pos[1]["x_low"] <= char.position.x and char.position.x<=benefitial_terrain_nodes_pos[1]["x_top"]:
		if benefitial_terrain_nodes_pos[1]["y_low"] <= char.position.y and char.position.y <=benefitial_terrain_nodes_pos[1]["y_top"]:
			char.recover()
			
	return char.steering

func player_is_visible(character,player):
	if g1.visibleF(player.position,character.position,all_vertexes,$"."):
		return true
	else:
		return false
	
	
func initialize_tactical_points_vals(nodes,type, char, follow_instance, colores : bool = false, color_list : Array = []):
	var cover_point_node = check_points(char, type, true)
	var closest_node = g1.closest_to_node(char.position)
	var heur = Heuristic.new(cover_point_node)
	var p = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	follow_instance.positions=pathfinding
	follow_instance.pos = 0
	if colores and pathfinding.size() > 1:
		var children = get_children(true)
		for child in children:
			if child is Line2D and (child.default_color == color_list[0] or child.default_color == color_list[1]):
				remove_child(child)
		create_lines(pathfinding,color_list[0],8)
		create_lines(p,color_list[1],4)
	
func initialize_pathfinding(char, follow_instance, colores : bool = false, color_list : Array = [], startNode : NodeR = NodeR.new(Vector2.ZERO)):
	var cover_point_node 
	if startNode.vector != Vector2.ZERO:
		cover_point_node = startNode	
	else:
		cover_point_node = g1.random_node()
	var closest_node = g1.closest_to_node(char.position)
	var heur = Heuristic.new(cover_point_node)
	var p = g1.pathfindAStar(g1,closest_node,cover_point_node,heur,$".")
	var pathfinding = g1.pathfindAStarModified(g1,closest_node,cover_point_node,heur,$".",tactic)
	follow_instance.positions=pathfinding
	follow_instance.pos = 0
	if colores and pathfinding.size() > 1:
		var children = get_children(true)
		for child in children:
			if child is Line2D and (child.default_color == color_list[0] or child.default_color == color_list[1]):
				remove_child(child)
		create_lines(pathfinding,color_list[0],8)
		create_lines(p,color_list[1],4)	

func create_lines(path,COLOR,thickness):
	var posicion2=0
	for x in path:
		if posicion2+1<=path.size()-1:
			var line = Line2D.new()
			line.add_point(path[posicion2],0)
			line.add_point(path[posicion2+1],1)
			line.default_color = COLOR
			line.width = thickness
			if COLOR in selected_colors or selected_colors == []:
				line.visible = true
			else:
				line.visible = false
			$'.'.add_child(line)
			posicion2+=1
	
var points_char7 = [Vector2(444,678)]
func decision_only_pathfinding(char,inst_follow):
	var following = inst_follow.walk_all()
	
	if inst_follow.positions.size() <= 1:
		initialize_pathfinding(char, inst_follow,true,colors_char5)
	else:
		if following != null:
			char.time=0.1
			char.steering = following
		else:
			initialize_pathfinding(char, inst_follow,true,colors_char5)
	char.modulate = FOLLOW_PATH_COLOR
	if old_modulate:
		char.modulate = old_modulation
	if differentiate:
		char.modulate = decision_colors[4]
	char.steering = detectCollisionCharacter(char)
		

const COVER_TYPE = "COVER"
const VIS_TYPE = "VISUAL"
const SNIPER_TYPE = "SNIPER"
const TERRAIN_TYPE = "TERRAIN"

func quality_of_tactical_nodes(TYPE):
	var characterSize = Vector2(20,20)
	var nodes= []
	if TYPE == COVER_TYPE:
		nodes = cover_node_
	elif TYPE == VIS_TYPE:
		nodes = visibility_node_
	elif TYPE == SNIPER_TYPE:
		nodes = sniper_node_
	elif TYPE == TERRAIN_TYPE:
		nodes = terrain_node_
	
	var dict_quality = {}
	for node in nodes:
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
		dict_quality[node] = quality
	return dict_quality

func point_with_bigger_quality(quality):
	var keys = quality.keys()
	var vals = quality.values()
	vals.sort()
	for key in keys:
		if quality[key] == vals[0]:
			return key
	return quality[keys[0]]
	

func check_points(char, TYPE, MAX):
	var quality = []
	if TYPE == COVER_TYPE:
		quality = cover_quality
	elif TYPE == VIS_TYPE:
		quality = vis_quality
	elif TYPE == SNIPER_TYPE:
		quality = sniper_quality
	else:
		quality = cover_quality
	var keys = quality.keys()
	var selected = point_with_bigger_quality(quality)
	var min = 0
	var distance = INF
	for key in keys:
		var heur = Heuristic.new(key)
		var node = g1.closest_to_node(char.position)
		var dist = g1.pathfindAStarCost(g1,node,key,heur,$".",tactic)
		if dist == -1:
			continue
		if dist <= distance and quality[key] >= min:
			distance = dist
			min = quality[key]
			selected = key
	return selected
		

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
	
	var a6 = MachineAction.new(COVER,1)
	
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a5,a4)
	
	var s3 = State.new(a3,a2,a2)
	
	var s4 = State.new(a4,a4,a5)
	
	var s5 = State.new(a5,a5,a1)
	
	var s6 = State.new(a6,a4,a5)
		
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
	
	var condition7 = FloatCondition.new(-20000,char.currentHealth,-1000)
	var t7 = Transition.new(MachineAction.new(COVER,1),s6,condition7)
	
	var condition8 = FloatCondition.new(50,char.currentHealth,100)
	var t8 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s5,condition8)
	
	s1.setTransitions([t4,t7])
	s2.setTransitions([t4,t7])
	#s3.setTransitions([0t3,t4])
	s4.setTransitions([t5,t7])	
	s5.setTransitions([t6,t4,t1,t7])
	s6.setTransitions([t8])
	
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
	
	var cond5 = FloatCondition.new(-20000,char.currentHealth,0)
	var condition5 = AndCondition.new(cond1,cond5)
	var t5 = Transition.new(MachineAction.new(COVER,2),s4,cond5)
		
	
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
	var a5 = MachineAction.new(COVER,1)
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	
	var s2 = State.new(a2,a1,a3)
	
	var s3 = State.new(a3,a2,a4)
	
	var s4 = State.new(a4,a3,a1)
	
	var s5 = State.new(a5,a4,a1)
	
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(WALK,3),s2,cond1)
	
	var condition2 = FloatCondition.new(0,player.position.distance_to(char.position),200)
	var con2 = AndCondition.new(condition2,cond1)
	var t2 = Transition.new(MachineAction.new(ATTACK,2),s3,con2)
	
	var condition3 = FloatCondition.new(0,player.currentHealth,70)
	var t3 = Transition.new(MachineAction.new(SNIPER,1),s4,condition3)

	var condition4 = FloatCondition.new(75,player.currentHealth,100)
	var t4 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,condition4)	
	
	var condition7 = FloatCondition.new(-20000,char.currentHealth,-1000)
	var t7 = Transition.new(MachineAction.new(COVER,1),s5,condition7)
	
	var condition8 = FloatCondition.new(50,char.currentHealth,100)
	var t8 = Transition.new(MachineAction.new(FOLLOW_PATH,3),s1,condition8)
	
	s1.setTransitions([t1,t3,t2,t7])
	s2.setTransitions([t3,t7])
	s3.setTransitions([t3,t7])
	s4.setTransitions([t4,t7])
	s5.setTransitions([t8])
	
	var machine = StateMachine.new(s1)
	return machine
	
func create_state_machine4(char,player):
	var a1 = MachineAction.new(FOLLOW_PATH,2)
	var a2 = MachineAction.new(THROW,2)
	var a3 = MachineAction.new(VISIBILITY,1)
	var a4 = MachineAction.new(COVER,1)
	#State action,entry,exit
	var s1 = State.new(a1,a1,a2)
	var s2 = State.new(a2,a1,a3)
	var s3 = State.new(a3,a2,a1)
	var s4 = State.new(a4,a3,a1)
	
	var cond1 = Condition.new()
	cond1.condition = player_is_visible(char,player)
	var t1 = Transition.new(MachineAction.new(THROW,2),s2,cond1)
	
	var condition4 = FloatCondition.new(0,player.currentHealth,60)
	var t2 = Transition.new(MachineAction.new(VISIBILITY,1),s3,condition4)	
	
	var condition3 = FloatCondition.new(60,player.currentHealth,100)
	var t3 = Transition.new(MachineAction.new(FOLLOW_PATH,2),s1,condition3)	
	
	var condition7 = FloatCondition.new(-20000,char.currentHealth,-1000)
	var t7 = Transition.new(MachineAction.new(COVER,1),s4,condition7)
	
	var condition8 = FloatCondition.new(50,char.currentHealth,100)
	var t8 = Transition.new(MachineAction.new(FOLLOW_PATH,2),s1,condition8)
	
	s1.setTransitions([t1,t2,t7])
	s2.setTransitions([t2,t7])
	s3.setTransitions([t3,t7])
	s4.setTransitions([t8])
	var machine = StateMachine.new(s1)
	return machine
	
	
#MACHINE DECISIONS
func decision_5(char,older_decision,inst_follow,walk_char,flee_char,attack_char,TYPE, colors, wait : int = 0, hammer : Array = []):
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
	var decision = found.value
	if decision == FOLLOW_PATH:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow,true,colors)
			older_decision = decision
		char.modulate = FOLLOW_PATH_COLOR
	elif decision == THROW:
		if older_decision != decision:
			initialize_pathfinding(char, inst_follow,true,colors)
			older_decision = decision
		char.modulate = THROW_COLOR
		wait+=1
		if wait==30:
			hammer.append(char.throw(target.position-char.position, get_angle_to(target.position)))
			wait=0
	elif decision == VISIBILITY:
		if older_decision != decision:
			initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow,true,colors)
			older_decision = decision
		char.modulate = VISIBILITY_COLOR
	elif decision == COVER:
		if older_decision != decision:
			initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow,true,colors)
			older_decision = decision
		char.modulate = COVER_COLOR
	elif decision == SNIPER:
		if older_decision != decision:
			initialize_tactical_points_vals(sniper_node,SNIPER_TYPE, char, inst_follow,true,colors)
			older_decision = decision
		char.modulate = SNIPER_COLOR
	elif decision == WALK:
		char.time=0.1
		char.modulate = WALK_COLOR
		char.steering = walk_char.getSteering()
		older_decision = decision
	elif decision == FLEE:
		char.time=0.1
		char.modulate = FLEE_COLOR
		char.steering = flee_char.getSteering()
		older_decision = decision
	elif decision == ATTACK:
		char.time=0.1
		char.modulate = ATTACK_COLOR
		char.steering = attack_char.getSteering()
		older_decision = decision
		
	if decision==FOLLOW_PATH or decision==VISIBILITY or decision==COVER or decision==SNIPER:
		var following = inst_follow.walk_all()
		if inst_follow.positions.size() <= 1:
			if decision == FOLLOW_PATH:
				initialize_pathfinding(char, inst_follow,true,colors)
			elif decision == VISIBILITY:
				initialize_tactical_points_vals(visibility_node,VIS_TYPE, char, inst_follow,true,colors)
			elif decision == COVER:
				initialize_tactical_points_vals(cover_node,COVER_TYPE, char, inst_follow,true,colors)
			elif decision == SNIPER:
				initialize_tactical_points_vals(sniper_node,SNIPER_TYPE, char, inst_follow,true,colors)
		else:
			if following != null:
				char.time=0.1
				char.steering = following
			else:
				if decision == FOLLOW_PATH:
					initialize_pathfinding(char, inst_follow,true,colors)
				elif decision == VISIBILITY:
					char.time = 0
					char.velocity = Vector2.ZERO
				elif decision == COVER:
					char.time = 0
					char.velocity = Vector2.ZERO
					char.currentHealth = 100
					char.play_animation_recharge()
				elif decision == SNIPER:
					char.time = 0
					char.velocity = Vector2.ZERO
					wait+=1
					if wait==30:
						hammer.append(char.throw(target.position-char.position, get_angle_to(target.position)))
						wait=0
	char.steering = detectCollisionCharacter(char)
	if old_modulate:
		char.modulate = old_modulation
	if differentiate:
		char.modulate = decision_colors[TYPE-1]
	return [older_decision,wait,hammer]


func check_hammer_collision(hammer_list,character):
	if hammer_list.size()>=1:
		var positions = []
		for x in range(hammer_list.size()-1):
			var hammer = hammer_list[x]
			var col = character.detectCollisionCharacter(hammer,[get_node("Player")])
			var col2 = character.detectCollisionWalls(hammer,layer)
			if col2[0]:
				character.remove_child(hammer)
				positions.append(x)
			if col[0]:
				#hammer_list.remove_at(x)
				character.remove_child(hammer)
				positions.append(x)
				target.damaged()
		for p in positions:
			hammer_list.remove_at(p)
	return hammer_list

func game_over():
	if can_die == false:
		return false
	if target.currentHealth <= -1:
		return true
	if target.currentHealth == 0:
		target.velocity = Vector2.ZERO
		$game_over_sound.play()
		target.currentHealth = -1
		return true
	else:
		return false
		

var counter = 0
var counter2 = 0
var hammers = []
var hammers2 =[]
var won = false
var older_dec = [FOLLOW_PATH,FOLLOW_PATH,FOLLOW_PATH,FOLLOW_PATH]
var can_die = false
var selected_colors = []
var running = [1,2,3,4,5]
func _process(delta: float) -> void:
	$Healthbar.updateDie(can_die)
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
		
		if 1 in running:
			var res1 = decision_5(character,older_dec[0],pathfollowing_char1,seek1,flee1,attack1,1,colors_char1)
			older_dec[0] = res1[0]	
		if 2 in running:
			var res2 = decision_5(character2,older_dec[1],pathfollowing_char2,seek2,flee2,attack2,2,colors_char2)
			older_dec[1] = res2[0]
		if 3 in running:
			var res3 = decision_5(character3,older_dec[2],pathfollowing_char3,seek3,flee3,attack3,3,colors_char3,counter,hammers)
			older_dec[2] = res3[0]
			counter = res3[1]
			hammers = res3[2]
			hammers = check_hammer_collision(hammers,character3)
		if 4 in running:
			var res4 = decision_5(character4,older_dec[3],pathfollowing_char4,seek4,flee4,attack4,4,colors_char4,counter2,hammers2)
			older_dec[3] = res4[0]
			counter2 = res4[1]
			hammers2 = res4[2]
			hammers2 = check_hammer_collision(hammers2,character4)
		
		if 5 in running:
			decision_only_pathfinding(character5,pathfollowing_char5)		
		
		if Input.is_action_just_pressed("enter"):
			var children = get_children(true)
			for child in children:
				if child is Line2D and child.default_color == Color.AQUAMARINE:
					child.visible = not child.visible
				elif child is Sprite2D:
					if child.texture.resource_path == graph_node_image_path:
						child.visible = not child.visible
		elif Input.is_action_just_pressed("visible_lines"): #x
			var children = get_children(true)
			for child in children:
				if child is Line2D:
					child.visible = not child.visible
				elif child is Sprite2D:
					if child.texture.resource_path == graph_node_image_path:
						child.visible = not child.visible
		elif Input.is_action_just_pressed("space"): #space
			old_modulate = not old_modulate
		elif Input.is_action_just_pressed("labels"): #l
			$Label.visible = not $Label.visible
		elif Input.is_action_just_pressed("differentiate_characters"): #s
			differentiate = not differentiate
		elif Input.is_action_just_pressed("die"):  #d
			can_die = not can_die
		elif Input.is_action_just_pressed("one"):
			visible_lines_color(colors_char1)
			make_characters_invisible_but(1)
			selected_colors = colors_char1
		elif Input.is_action_just_pressed("two"):
			visible_lines_color(colors_char2)
			make_characters_invisible_but(2)
			selected_colors = colors_char2
		elif Input.is_action_just_pressed("three"):
			visible_lines_color(colors_char3)
			make_characters_invisible_but(3)
			selected_colors = colors_char3
		elif Input.is_action_just_pressed("four"):
			visible_lines_color(colors_char4)
			make_characters_invisible_but(4)
			selected_colors = colors_char4
		elif Input.is_action_just_pressed("five"):
			visible_lines_color(colors_char5)
			make_characters_invisible_but(5)
			selected_colors = colors_char5
		elif Input.is_action_just_pressed("all_char_visible"): #0
			var children = get_children(true)
			for child in children:
				if child is Line2D:
					child.visible = true
			var chars = [character,character2,character3,character4,character5]
			for char in chars:
				char.visible = true
			selected_colors = []
		elif Input.is_action_just_pressed("visible_tactical_nodes"): #w
			var children = get_children(true)
			for child in children:
				if child is Sprite2D:
					var images = [cover_image,vis_image,sniper_image,terrain_image,terrain_benefitial_image,terrain_non_benefitial_image]
					if child.texture.resource_path in images:
						child.visible = not child.visible
			
			
func make_characters_invisible_but(val):
	var chars = [character,character2,character3,character4,character5]
	for y in range(chars.size()):
		if y == val-1:
			chars[y].visible = true
		else:
			chars[y].visible = false
		

func visible_lines_color(color):
	var children = get_children(true)
	for child in children:
		if child is Line2D and child.default_color != color[0] and child.default_color != color[1]:
			child.visible = false
		
