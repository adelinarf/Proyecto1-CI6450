extends Node2D


var global_tile_pos = []
var character
var target
var new
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var used_cells = $TileMapLayer.get_used_cells()
	for n in used_cells:
		var tile_center_pos = $TileMapLayer.map_to_local(n)
		global_tile_pos.append_array([tile_center_pos])
	character = get_node("Character")
	target = get_node("Player")
	new = FollowPath.new(character,target,global_tile_pos)
	character.disableArrows()
	target.disableArrows()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.steering = new.getSteeringPrediction()
