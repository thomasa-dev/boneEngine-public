extends Camera

export var pullPower : float = 12

onready var rayCast = $RayCast
onready var holdPosition = $HoldPosition

var pickedObject
var objectToDelete
var hasCollided = false
var isRigid = true

func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_pressed("grabAim"):
		if pickedObject == null:
			grab()
	else:
		dropObject()

	# Object picking
	if pickedObject != null:
		var objectPosition = pickedObject.global_transform.origin
		var handPosition = holdPosition.global_transform.origin
		pickedObject.set_linear_velocity((handPosition-objectPosition) * pullPower)

func grab(): # picking up the object
	var collider = rayCast.get_collider()
	if collider != null and collider is RigidBody:
		pickedObject = collider

func dropObject(): # dropping the object
	if pickedObject != null:
		pickedObject.look_at(Vector3.UP, Vector3(0, 1, 0))
		pickedObject = null
