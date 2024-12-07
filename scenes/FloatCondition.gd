class_name FloatCondition
extends Condition

var minValue
var maxValue
var testValue # Pointer to the game data we’re interested in

func _init(min,test,max) -> void:
	self.minValue = min
	self.maxValue = max 
	self.testValue = test

func test():
	return minValue <= testValue and testValue <= maxValue
