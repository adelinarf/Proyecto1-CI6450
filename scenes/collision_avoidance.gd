extends Node2D

var character
var character2
var character3
var character4
var character5
var character6
var character7
var character8
var character9
var character10


var target
var new
var new2
var new3
var new4
var new5
var new6
var new7
var new8
var new9
var new10

var new_
var new_2
var new_3
var new_4
var new_5
var new_6
var new_7
var new_8
var new_9
var new_10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	character6 = get_node("Character6")
	character7 = get_node("Character7")
	character8 = get_node("Character8")
	character9 = get_node("Character9")
	character10 = get_node("Character10")
	
	target = get_node("Player")
	character.disableCollisions()
	character2.disableCollisions()
	character3.disableCollisions()
	character4.disableCollisions()
	character5.disableCollisions()
	character6.disableCollisions()
	character7.disableCollisions()
	character8.disableCollisions()
	character9.disableCollisions()
	character10.disableCollisions()
	
	target.disableCollisions()
	
	new = CollisionAvoidance.new(character,[target,character2,character3,character4,
	character5,character6,character7,character8,character9,character10])
	new2 = CollisionAvoidance.new(character2,[target,character,character3,character4,
	character5,character6,character7,character8,character9,character10])
	new3 = CollisionAvoidance.new(character3,[target,character2,character,character4,
	character5,character6,character7,character8,character9,character10])
	new4 = CollisionAvoidance.new(character,[target,character2,character3,character,
	character5,character6,character7,character8,character9,character10])
	new5 = CollisionAvoidance.new(character,[target,character2,character3,character4,
	character,character6,character7,character8,character9,character10])
	new6 = CollisionAvoidance.new(character6,[target,character2,character3,character4,
	character5,character,character7,character8,character9,character10])
	new7 = CollisionAvoidance.new(character7,[target,character2,character3,character4,
	character5,character6,character,character8,character9,character10])
	new8 = CollisionAvoidance.new(character8,[target,character2,character3,character4,
	character5,character6,character7,character,character9,character10])
	new9 = CollisionAvoidance.new(character9,[target,character2,character3,character4,
	character5,character6,character7,character8,character,character10])
	new10 = CollisionAvoidance.new(character10,[target,character2,character3,character4,
	character5,character6,character7,character8,character9,character])
	
	new_ = Wander.new(character,target)
	new_2 = Wander.new(character2,target)
	new_3 = Wander.new(character3,target)
	new_4 = Wander.new(character4,target)
	new_5 = Wander.new(character5,target)
	new_6 = Wander.new(character6,target)
	new_7 = Wander.new(character7,target)
	new_8 = Wander.new(character8,target)
	new_9 = Wander.new(character9,target)
	new_10 = Wander.new(character10,target)
	
	target.disableArrows()
	
	character.disableArrows()
	character2.disableArrows()
	character3.disableArrows()
	character4.disableArrows()
	character5.disableArrows()
	character6.disableArrows()
	character7.disableArrows()
	character8.disableArrows()
	character9.disableArrows()
	character10.disableArrows()
	#al menos 10 personajes con dynamic wander evitandose

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#wander
	character.steering = new_.getSteering()
	character2.steering = new_2.getSteering()
	character3.steering = new_3.getSteering()
	character4.steering = new_4.getSteering()
	character5.steering = new_5.getSteering()
	character6.steering = new_6.getSteering()
	character7.steering = new_7.getSteering()
	character8.steering = new_8.getSteering()
	character9.steering = new_9.getSteering()
	character10.steering = new_10.getSteering()	
	
	#collision
	character.steering = new.getSteering()
	character2.steering = new2.getSteering()
	character3.steering = new3.getSteering()
	character4.steering = new4.getSteering()
	character5.steering = new5.getSteering()
	character6.steering = new6.getSteering()
	character7.steering = new7.getSteering()
	character8.steering = new8.getSteering()
	character9.steering = new9.getSteering()
	character10.steering = new10.getSteering()
	
	
	
