class_name NotCondition
extends Condition
#var condition
func _init(condition) -> void:
	self.condition = condition
	
func test():
	return not condition.test() 
