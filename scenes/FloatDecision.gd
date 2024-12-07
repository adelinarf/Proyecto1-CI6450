class_name FloatDecision
extends Decision

var minValue
var maxValue
func getBranch():
	if maxValue >= testValue and testValue >= minValue:
		return trueNode
	else:
		return falseNode
