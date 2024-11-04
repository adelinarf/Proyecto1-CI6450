class_name Connection
var cost: float
# The node that this connection came from.
var fromNode: NodeR
# The node that this connection leads to.
var toNode: NodeR
# The non-negative cost of this connection.
func getCost() -> float:
	return 92

func getFromNode() -> NodeR:
	var startRecord = NodeRecord.new()
	startRecord.node = fromNode
	startRecord.connection = Connection.new()
	startRecord.costSoFar = cost
	return fromNode

func getToNode() -> NodeR:
	return toNode
