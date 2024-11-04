extends CanvasLayer

@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "SCORE 0"
	player.healthChanged.connect(update)
	player.scoreChanged.connect(updateScore)
	update()

func update():
	$ProgressBar.value = player.currentHealth * 100 / player.maxHealth
	$TextureProgressBar.value = player.currentHealth * 100 / player.maxHealth
	$RichTextLabel2.text = "HEALTH = "+str($ProgressBar.value)
func updateScore():
	$RichTextLabel.text = "SCORE = "+str(player.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
