class_name AvailableDecision

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
	
func decision_new(character,player):
	var action7 = Action.new(ATTACK)
	var action8 = Action.new(GUARD)
	var action = Action.new(COVER)
	var dec5 = Decision.new(action,action7,distance_less_than(200,character,player))
	var d3 = Decision.new(dec5,action8,player_is_visible(character,player))
	return d3
	
func decision_new2(character,player):
	var action8 = Action.new(GUARD)
	var action = Action.new(COVER)
	var d3 = Decision.new(action,action8,player_is_visible(character,player))
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
	
	
