class_name OrCondition
extends Condition
var conditionA
var conditionB

func test():
	return conditionA.test() or conditionB.test()
