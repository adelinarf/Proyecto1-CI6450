extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("closed")

func _open() -> void:
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_looped
	$AnimatedSprite2D.play("opened")
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
