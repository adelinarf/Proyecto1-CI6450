extends CanvasLayer

@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "SCORE  0"
	player.healthChanged.connect(update)
	player.scoreChanged.connect(updateScore)
	update()

func updateDie(val):
	if val==true:
		$RichTextLabel3.text = "CAN DIE? YES"
	else:
		$RichTextLabel3.text = "CAN DIE? NO"

func update():
	$ProgressBar.value = player.currentHealth * 100 / player.maxHealth
	$TextureProgressBar.value = player.currentHealth * 100 / player.maxHealth
	$RichTextLabel2.text = "HEALTH = "+str($ProgressBar.value)
func updateScore():
	$RichTextLabel.text = "SCORE  "+str(player.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Show.show:
		$RichTextLabel3.visible = true
		$info.visible = true
		$info.disabled = false		
	else:
		$RichTextLabel3.visible = false
		$info.visible = false
		$info.disabled = true
		


func _on_button_pressed() -> void:
	Show.paused = true
	get_tree().paused = true
	show()
	$game_over_menu.visible = true 
	$game_over_menu.paused()
	


func _on_info_mouse_entered() -> void:
	$info2.visible=true

func _on_info_mouse_exited() -> void:
	$info2.visible=false

func _on_sound_pressed() -> void:
	if Show.sound:
		Show.sound = false
	else:
		Show.sound = true
