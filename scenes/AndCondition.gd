class_name AndCondition
extends Condition
var conditionA
var conditionB

func _init(condA,condB) -> void:
	self.conditionA=condA
	self.conditionB=condB

func test():
	return conditionA.test() and conditionB.test()
