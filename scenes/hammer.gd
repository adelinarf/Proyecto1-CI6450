extends CharacterBody2D


@export var time = 0.1
@export var SPEED = 0.0
const JUMP_VELOCITY = -400.0
var orientation : float = 0.0
var maxSpeed = 10
#angulo en sentido antihorario desde el eje y (z)
func update(linear : Vector2, angular: float, time: float) -> void:
	# Update the position and orientation.
	position += velocity * time
	orientation += rotation * time
	#print(orientation)
	velocity += linear * time
	rotation += angular * time
	if velocity.length() > maxSpeed:
		velocity = velocity.normalized()
		velocity *= maxSpeed

var steering
func _ready() -> void:
	steering = SteeringOutput.new(Vector2(SPEED,0.0),0.0)

func _physics_process(delta: float) -> void:
	update(steering._lineal(), steering._angular(), time)
	rotation+=20
	move_and_slide()
