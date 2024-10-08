extends Node


var character
func _ready() -> void:
	pass #character = get_node("Character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/kinematic_arrive.tscn")


func _on_option_button_item_selected(index: int) -> void:
	var paths = ["res://scenes/kinematic_arrive.tscn","res://scenes/kinematic_flee.tscn",
	"res://scenes/kinematic_wandering.tscn","res://scenes/dynamic_seek.tscn",
	"res://scenes/dynamic_flee.tscn","res://scenes/arrive.tscn","res://scenes/align.tscn",
	"res://scenes/velocity_matching.tscn","res://scenes/face.tscn","res://scenes/pursue.tscn",
	"res://scenes/evade.tscn","res://scenes/wander.tscn","res://scenes/path_following.tscn",
	"res://scenes/separation.tscn","res://scenes/collision_avoidance.tscn",
	"res://scenes/obstacle_avoidance.tscn","res://scenes/wander2.tscn",
	"res://scenes/pursueandevade.tscn"]
	get_tree().change_scene_to_file(paths[index])
		
