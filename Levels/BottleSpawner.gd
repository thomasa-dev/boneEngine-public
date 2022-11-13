extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	pass
	#if Input.is_action_just_pressed("spawnBottle"):
	#	spawnBottle()


# spawning object function

func spawnBottle():
			# loading the scenes to spawn in
	var bottleObject = preload("res://assets/bottle.tscn")

	# creating the instances
	var bottleInstance = bottleObject.instance()
	
	add_child(bottleInstance)
