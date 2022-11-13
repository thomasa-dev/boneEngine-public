extends KinematicBody


export var walkSpeed : float = 12
export var sprintSpeed : float = 24
export var gravity : float = 9.8
export var jump : int = 5

export var mouseSensitivity : float = 0.05
export var controllerSensitivity : float = 4

onready var speed = walkSpeed
var acceleration = 20
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()
var collider
var shotObject
var isGrounded = true
var fireType = Globals.gunFireMode

var fireModes = Globals.gunFireTypes
var maxFireMode = Globals.maxFireMode

onready var gunCast = $Head/Camera/GunCast
onready var animPlayer = $AnimationPlayer
onready var head = $Head
onready var groundCheck = $GroundCheck
onready var pauseMenu = $Control
onready var FPSCounter = $FPSCounter

onready var bulletDecal = load("res://Extras/Bullet-Decals.tscn")

#### CUSTOM FUNCTIONS ####

# Sprint function
func playerSprint(walkSpeed, sprintSpeed):
	# Sprinting
	if Input.is_action_pressed("sprint"): # checking if left-shift is held down
		speed = sprintSpeed
	else:
		speed = walkSpeed

# Fire gun function
func fire(): # fireGun
	animPlayer.play("m4Anim")
	var collider = gunCast.get_collider()
	if collider != null:
		if collider is RigidBody:
			shotObject = collider
			print("Shot fired at RigidBody")
			if "Bottle" in shotObject.name:
				shotObject.queue_free()


# Checks if player is grounded
func checkGround():
	if groundCheck.is_colliding(): # checking if the groundCheck raycast is colliding with the ground
		var collidingWith = groundCheck.get_collider()
		if collidingWith.name == "Ground":
			isGrounded = true
	else:
		isGrounded = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks the cursor to the game

# Whenever an input is sent to the game
func _input(event):
	if not pauseMenu.isPaused:
		if event is InputEventMouseMotion:
			# Rotating the X and Y axis of the camera to look around
			rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouseSensitivity)) # head.rotate_x is used otherwise the looking goes wonkey

			# Clamping the head rotation
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	
	apply_controller_rotation()
	
	FPSCounter.text = "FPS : " + str(Engine.get_frames_per_second()) # getting the games FPS and setting the FPSlabel's text to the FPS
	
	
	if not pauseMenu.isPaused: # if the game isn't paused
		
		checkGround()
		
		# For shooting
		if fireType == 0: # semi-auto
			if Input.is_action_just_pressed("shoot"):
				fire()
		elif fireType == 1: # full-auto
			if Input.is_action_pressed("shoot"):
				fire()
		
		if Input.is_action_just_pressed("switchFireMode"): # switching the guns firemode
			if fireType < maxFireMode:
				fireType += 1
			else:
				fireType = 0
			print("Fire Mode: " + fireModes[fireType])

# Updates every frame
func _process(delta):
	if not pauseMenu.isPaused:
		
		$CrossHair.visible = true
		
		## Running the custom functions
		playerSprint(walkSpeed, sprintSpeed)

		direction = Vector3() # resetting the direction to 0 every frame

		if not is_on_floor(): # E
			fall.y -= gravity * delta
		
		# Jumping
		if Input.is_action_just_pressed("jump") and isGrounded:
			fall.y = jump
		
		# Move forwards
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z # Moves player forward
		
		# Move backwards
		elif Input.is_action_pressed("move_backward"):
			direction += transform.basis.z # Moves player forward

		# Move left
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x # Moves player forward

		# Move right
		elif Input.is_action_pressed("move_right"):
			direction += transform.basis.x # Moves player forward



		# Moving the player
		direction = direction.normalized() # making sure the player doesn't move faster going diagonally
		velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) # moving the player
		velocity = move_and_slide(velocity, Vector3.UP) # actually moving the player
		move_and_slide(fall, Vector3.UP) # Making the player jump
	else:
		$CrossHair.visible = false





func apply_controller_rotation():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("clook_right") - Input.get_action_strength("clook_left")
	axis.y = Input.get_action_strength("clook_down") - Input.get_action_strength("clook_up")

	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axis.x) * controllerSensitivity)
		head.rotate_x(deg2rad(-axis.y) * controllerSensitivity)

