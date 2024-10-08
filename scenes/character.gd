extends CharacterBody2D

@export var kinematic = false
@export var time = 0.1
const SPEED = 0.0
const JUMP_VELOCITY = -400.0
var orientation : float = 0.0
var maxSpeed = 10
#angulo en sentido antihorario desde el eje y (z)
func update(linear : Vector2, angular: float, time: float) -> void:
	if kinematic == true:
		position += velocity * time
		orientation += rotation * time
		velocity += linear * time
		rotation += angular * time
	else:
		# Update the position and orientation.
		position += velocity * time
		orientation += rotation * time
		#print(orientation)
		velocity += linear * time
		rotation += angular * time
		$AnimatedSprite2D.rotation = -rotation
		if velocity.length() > maxSpeed:
			velocity = velocity.normalized()
			velocity *= maxSpeed

var steering
func _ready() -> void:
	if kinematic == true:
		steering = KinematicSteeringOutput.new(Vector2(SPEED,0.0),0.0)
	else:
		steering = SteeringOutput.new(Vector2(SPEED,0.0),0.0)

func cardToPolar(x:float,y:float) -> float:
	return atan(y/x)

func polarToCard(d:float) -> Vector2:
	var y = -cos(d*PI/180)
	var x = sin(d*PI/180)
	return Vector2(x,y)

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
	#print(orientation,"still")
	#$Arrow.rotation_degrees = convertToDegree()
		#steer_character()
func disableCollisions():
	$Arrow/CollisionShape2D.disabled=true
	$Arrow2/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true

func arrow_position(ray):
	$Arrow2.position = ray
	
func disableArrows():
	$Arrow/CollisionShape2D.disabled = true
	$Arrow2/CollisionShape2D.disabled=true
	$Arrow.visible = false
	$Arrow2.visible = false
	$circle.visible = false
	$target.visible = false
	$circle/CollisionShape2D.disabled = true
	$target/CollisionShape2D.disabled = true
	
func disableShow():
	$Arrow/CollisionShape2D.disabled = true
	$Arrow2/CollisionShape2D.disabled=true
	$Arrow2.visible = false
	$circle.visible = false
	$target.visible = false
	$circle/CollisionShape2D.disabled = true
	$target/CollisionShape2D.disabled = true
	
func disableWanderElements():
	$circle.visible = false
	$target.visible = false
	$circle/CollisionShape2D.disabled = true
	$target/CollisionShape2D.disabled = true
	
func disableArrows2():
	$Arrow/CollisionShape2D.disabled = true
	$Arrow2/CollisionShape2D.disabled=true
	$Arrow.visible = false
	$Arrow2.visible = false
	$circle/CollisionShape2D.disabled = true
	$target/CollisionShape2D.disabled = true
	
func disableCollisionArrow():
	$Arrow2/CollisionShape2D.disabled=true
	$Arrow2.visible = false
	
func disableOrientationArrow():
	$Arrow/CollisionShape2D.disabled = true
	$Arrow.visible = false


func arrow2_position(ray):
	$Arrow2.position = ray
	
func convertToDegree() -> float:
	#print(orientation,"orie")
	var d = orientation*180/PI
	print(d)
	return d

func steer_character() -> void:
	var degree = convertToDegree()
	if 0 <= degree or degree < 90:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("right") #derecha
	elif degree == 90:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("up") #arriba
	elif 90 < degree or degree<= 180:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("right") #derecha
	elif degree > 180:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("down") #arriba

func _physics_process(delta: float) -> void:
	#print(orientation,"chra")
	 #cardToPolar(global_transform[2][0],global_transform[2][1])
	
	if kinematic == true:
		#orientation = steering._rotation()
		update(steering._velocity(), steering._rotation(), time)	
	else:
		#orientation = (steering._angular()*10)
		update(steering._lineal(), steering._angular(), time)
	play_animation()
	move_and_slide()
	#$Arrow.rotation_degrees = - global_rotation_degrees
	$Arrow.rotation_degrees = -global_rotation_degrees + orientation*180/PI
	#$Arrow.ro = orientation - rotation

func _position() -> Vector2:
	return position
func _velocity() -> Vector2:
	return velocity
func _skew() -> float:
	return skew
	
func _orientation() -> float:
	return orientation

func newOrientation(current : float, velocity : Vector2) -> float:
	if velocity.length() > 0:
		return atan2(-velocity.x,velocity.y)
	else:
		return current
		
func change_target_pos(v : Vector2) -> void:
	$target.global_position = v
	
func change_circle_pos(v : Vector2, radius : float) -> void:
	$circle/Sprite2D.draw_circle(v,radius,'#ffff')
	$circle.global_position = v
