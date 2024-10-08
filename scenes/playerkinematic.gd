extends CharacterBody2D

var orientation : float = 0.0
const SPEED = 10.0
const JUMP_VELOCITY = -400.0

func update(linear : Vector2, angular: float, time: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var direction2 := Input.get_axis("ui_down", "ui_up")
	position += velocity * time
	orientation += rotation * time
	velocity += direction * linear * time
	rotation += angular * time
	
func updateY(linear : Vector2, angular: float, time: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var direction2 := Input.get_axis("ui_down", "ui_up")
	position += velocity * time
	orientation += rotation * time
	velocity.y += linear.y * time
	rotation += angular * time

func cardToPolar(x:float,y:float) -> float:
	return atan(y/x)

func play_animation () -> void:
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("right") #derecha
	elif velocity.x < 0:
		$AnimatedSprite2D.play("right") #izquierda
		$AnimatedSprite2D.flip_h = true
	elif velocity.y > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("up") #arriba
	elif velocity.y < 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("down") #abajo
	elif velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("still") #parado

func disableArrows():
	$Arrow/CollisionShape2D.disabled=true
	$Arrow.visible = false

func disableCollisions():
	$Arrow/CollisionShape2D.disabled=true
	$CollisionShape2D.disabled = true
	
func _physics_process(delta: float) -> void:
	#print(atan2(-velocity.x, velocity.y))
	orientation = atan2(-velocity.x, velocity.y) #cardToPolar(global_transform[2][0],global_transform[2][1])
	var time = 0.1

	var linear = Vector2(SPEED, 0.0)
	var linear2 = Vector2(0.0, SPEED)
	var steering = SteeringOutput.new(linear,0.0)
	var angular = 0.0
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("right")
		update(linear, angular, time)
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("right") #izquierda
		$AnimatedSprite2D.flip_h = true
		update(linear, angular, time)
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("down")
		updateY(linear2, angular, time)
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("up")
		updateY(-linear2, angular, time)	
	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("still")
		velocity = Vector2(0.0,0.0)
	move_and_slide()
	$Arrow.rotation_degrees = convertToDegree()

func convertToDegree() -> float:
	var d = orientation*180/PI
	#-90 derecha, 90 izquierda, -180 arriba, -0 abajo 
	return d
	
func _position() -> Vector2:
	return position
	
func _orientation() -> float:
	return orientation
