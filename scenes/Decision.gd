class_name Decision
extends DecisionTreeNode

# trueNode and falseNode members are pointers to other nodes in the tree,
#and the testValue member points to the piece of data in the character’s knowledge
#which will form the basis of the test. 
var trueNode
var falseNode
var testValue

func _init(trueNode, falseNode, testValue) -> void:
	self.trueNode = trueNode
	self.falseNode = falseNode
	self.testValue = testValue

func getBranch():
	pass # carries out the test
	
func makeDecision():
	var current_trueNode = trueNode
	var current_falseNode = falseNode
	var current_testValue = testValue
	
	while current_falseNode.get_script().resource_path != 'res://scenes/Action.gd' and current_trueNode.get_script().resource_path != 'res://scenes/Action.gd':
		if current_testValue == true:
			current_falseNode = current_trueNode.falseNode
			current_testValue = current_trueNode.testValue
			current_trueNode = current_trueNode.trueNode
		else:
			current_trueNode = current_falseNode.trueNode
			current_testValue = current_falseNode.testValue
			current_falseNode = current_falseNode.falseNode
		
	var a 
	if current_testValue == true:
		a = current_trueNode.makeDecision()
	else:
		a = current_falseNode.makeDecision()
	return a
	# Recursively walks through the tree
