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

var vnew
var vnew2
var vnew3
var vnew4
var vnew5
var vnew6
var vnew7
var vnew8
var vnew9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#aplicar velocity matching
	character = get_node("Character")
	character2 = get_node("Character2")
	character3 = get_node("Character3")
	character4 = get_node("Character4")
	character5 = get_node("Character5")
	character6 = get_node("Character6")
	character7 = get_node("Character7")
	character8 = get_node("Character8")
	character9 = get_node("Character9")
	target = get_node("Player")
	new = Separation.new(character,[target,character2,character3,character4,
	character5,character6,character7,character8,character9])
	new2 = Separation.new(character2,[target,character,character3,character4,
	character5,character6,character7,character8,character9])
	new3 = Separation.new(character3,[target,character2,character,character4,
	character5,character6,character7,character8,character9])
	new4 = Separation.new(character4,[target,character2,character3,character,
	character5,character6,character7,character8,character9])
	new5 = Separation.new(character5,[target,character2,character3,character4,
	character,character6,character7,character8,character9])
	new6 = Separation.new(character6,[target,character2,character3,character4,
	character5,character,character7,character8,character9])
	new7 = Separation.new(character7,[target,character2,character3,character4,
	character5,character6,character,character8,character9])
	new8 = Separation.new(character8,[target,character2,character3,character4,
	character5,character6,character7,character,character9])
	new9 = Separation.new(character9,[target,character2,character3,character4,
	character5,character6,character7,character8,character])
	vnew = VelocityMatching.new(character,target)
	vnew2 = VelocityMatching.new(character2,target)
	vnew3 = VelocityMatching.new(character3,target)
	vnew4 = VelocityMatching.new(character4,target)
	vnew5 = VelocityMatching.new(character5,target)
	vnew6 = VelocityMatching.new(character6,target)
	vnew7 = VelocityMatching.new(character7,target)
	vnew8 = VelocityMatching.new(character8,target)
	vnew9 = VelocityMatching.new(character9,target)
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
	
	#character.disableCollisions()
	#character2.disableCollisions()
	#character3.disableCollisions()
	#character4.disableCollisions()
	#character5.disableCollisions()
	#character6.disableCollisions()
	#character7.disableCollisions()
	#character8.disableCollisions()
	#character9.disableCollisions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ch1= vnew.getSteering()
	character.steering = new.getSteering(ch1)
	
	var ch2 = vnew2.getSteering()
	character2.steering = new2.getSteering(ch2)
	
	var ch3 = vnew3.getSteering()
	character3.steering = new3.getSteering(ch3)
	
	var ch4 = vnew4.getSteering()
	character4.steering = new4.getSteering(ch4)
	
	var ch5 = vnew5.getSteering()
	character5.steering = new5.getSteering(ch5)
	
	var ch6 = vnew6.getSteering()
	character6.steering = new6.getSteering(ch6)
	
	var ch7 = vnew7.getSteering()
	character7.steering = new7.getSteering(ch7)
	
	var ch8 = vnew8.getSteering()
	character8.steering = new8.getSteering(ch8)
	
	var ch9 = vnew9.getSteering()
	character9.steering = new9.getSteering(ch9)
	
	
	
	
	
	
