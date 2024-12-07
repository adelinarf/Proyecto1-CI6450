extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Show.paused:
		$RichTextLabel.text = "PAUSED"
		$VBoxContainer/Restart.text = "Resume"
	elif Show.game_over:
		$RichTextLabel.text = "GAME OVER"
		$VBoxContainer/Restart.text = "Restart"
func paused():
	$RichTextLabel.text = "PAUSED"
	$VBoxContainer/Restart.text = "Resume"
func game_over():
	$RichTextLabel.text = "GAME OVER"
	$VBoxContainer/Restart.text = "Restart"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_restart_pressed() -> void:
	if Show.paused:
		hide()
		get_tree().paused = false
		$".".visible = false
		Show.paused = false
	if Show.game_over:
		hide()
		Show.paused = false
		Show.game_over = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_new_game_pressed() -> void:
	Show.game_over = false
	Show.paused = false
	get_tree().paused=false
	get_tree().change_scene_to_file("res://main_menu.tscn")
