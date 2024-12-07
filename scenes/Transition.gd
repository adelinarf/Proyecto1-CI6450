class_name Transition
var actions : MachineAction
var targetState : State
var condition : Condition

func _init(actions,targetState,condition) -> void:
	self.actions=actions
	self.targetState=targetState
	self.condition = condition

func isTriggered():
	return condition.test()

func getTargetState():
	return targetState
	
func getAction():
	return actions
