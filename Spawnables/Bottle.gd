extends RigidBody


# Called when the node enters the scene tree for the first time.
func _ready():
	print("bottle loaded")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		print("jumped")
