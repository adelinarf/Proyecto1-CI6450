class_name State

var action
var entry
var exit
var transitions
func _init(action,entry,exit) -> void:
	self.action = action
	self.entry = entry 
	self.exit = exit 

func setTransitions(t):
	self.transitions = t

func getAction():
	# The rest of the time that the state is active, getAction is called. T
	return action
	
func getEntryAction():
	#the getEntryAction is only called when the state is entered from a transition
	return entry
	
func getExitAction():
	#the getExitAction is only called when the state is exited
	return exit
	
func getTransitions():
	#The getTransitions method should return a list of transitions that are outgoing from this state
	return transitions
