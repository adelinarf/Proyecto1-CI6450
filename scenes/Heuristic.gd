class_name Heuristic

# Stores the goal node that this heuristic is estimating for.
var goalNode: NodeR

func _init(end : NodeR) -> void:
	goalNode = end

# Estimated cost to reach the stored goal from the given node.
func estimate(fromNode: NodeR) -> float:
	return estimatex(fromNode, goalNode)

# Estimated cost to move between any two nodes.
func estimatex(fromNode: NodeR, toNode: NodeR) -> float:
	var from = int(fromNode.name)
	var to = int(toNode.name)
	return to-from
