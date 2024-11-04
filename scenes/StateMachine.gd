class_name StateMachine
# Holds a list of states for the machine
var states

# Holds the initial state
var initialState
# Holds the current state
var currentState = initialState

func _init(initialState) -> void:
	self.initialState=initialState
	self.currentState=initialState

func custom_array_sort(a, b):
	if a.priority < b.priority:
		return true
	else:
		return false

func order_actions_by_priority(actions):
	return actions.custom_sort(self, "custom_array_sort");
# Checks and applies transitions, returning a list of
# actions.
func update():

	# Assume no transition is triggered
	var triggeredTransition = null
	# Check through each transition and store the first
	# one that triggers.
	var priority = 10000
	for transition in currentState.getTransitions():
		if transition.isTriggered():
			#print(transition.actions.value," action triggered")
			#print(transition.condition)
			#print(a.value,"EXIT ACTION")
			if transition.actions.priority <= priority:
				triggeredTransition = transition
				#print(triggeredTransition.actions.value,"=selected action")
				priority = transition.actions.priority
			#break
		#else:
			#print(transition.actions.value," action not triggered")
	
	# Check if we have a transition to fire
	if triggeredTransition:
		# Find the target state
		var targetState = triggeredTransition.getTargetState()
	# Add the exit action of the old state, the
	# transition action and the entry for the new state.
		var actions = [currentState.getExitAction()]
		#print(actions)
		#print(actions.value)
		actions.append(triggeredTransition.getAction())
		actions.append(targetState.getEntryAction())
		
		# Complete the transition and return the action list
		currentState = targetState
		return actions
	# Otherwise just return the current state’s actions
	else:
		return [currentState.getAction()]
