extends CanvasLayer


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


#1 a 8  decision
#9 a 18 states colors


#var statesColor = [WALK_COLOR,ATTACK_COLOR,EVADE_COLOR,FOLLOW_PATH_COLOR,FOLLOW_PLAYER_COLOR,THROW_COLOR,UPDATE_TARGET_COLOR,WANDER_COLOR,FLEE_COLOR,GUARD_COLOR]

#var decisionColor = [color1,color2,color3,color4,color5,color6,color7,color8]

func getNodes(name : String,start : int, number : int) -> Array:
	var arr = []
	for x in range(start,number+1):
		#print(x,"GETNODES")
		arr.append(get_node(name+str(x)))
	return arr
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func changeColors(decisions,states):
	var decisionsSprites = getNodes("sprite",1,8)
	var last = get_node("sprite19")
	decisionsSprites.append(last)
	var statesSprites = getNodes("sprite",9,18)
	for x in range(decisionsSprites.size()):
		decisionsSprites[x].modulate = decisions[x]
	for x in range(states.size()):
		statesSprites[x].modulate = states[x]
		

func changeColorsSecond(decisions,states,states_text,tactical):
	var decisionsSprites = getNodes("sprite",1,8)
	var last = getNodes("sprite",19,25)
	decisionsSprites.append_array(last)
	var decisionText = getNodes("RichTextLabel",1,8)
	var lastTextDecision = getNodes("RichTextLabel",19,25)
	decisionText.append_array(lastTextDecision)
	var statesSprites = getNodes("sprite",9,18)
	var statesText = getNodes("RichTextLabel",9,18)
	
	for x in range(decisionsSprites.size()):
		if x<=decisions.size()-1:
			decisionsSprites[x].modulate = decisions[x]
		else:
			decisionsSprites[x].texture = load(tactical[x-decisions.size()][0])
			decisionsSprites[x].region_enabled = false
			decisionText[x].text = tactical[x-decisions.size()][1]
	for x in range(states.size()):
		if x<=states.size()-1:
			statesSprites[x].modulate = states[x]
			statesText[x].text = states_text[x]
		else:
			statesSprites[x].visible = false
			statesText[x].visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
