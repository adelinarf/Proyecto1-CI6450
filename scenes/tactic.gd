class_name Tactic

var weights : Dictionary
var tactics : Dictionary
func _init(weights : Dictionary, tactics : Dictionary) -> void:
	self.weights = weights
	self.tactics = tactics
	
func weight(from,to):
	if self.weights.has(from.vector):
		return self.weights[from.vector]
	elif self.weights.has(to.vector):
		return self.weights[to.vector]
	return 0
	
func tactic(from,to):
	if self.tactics.has(from.vector):
		return self.tactics[from.vector]
	elif self.tactics.has(to.vector):
		return self.tactics[to.vector]
	return 0
