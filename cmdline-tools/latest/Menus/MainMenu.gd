extends Control


onready var quitButton = $quitButton
onready var sandboxButton = $sandboxButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sandboxButton.is_pressed():
		self.visible = false
		get_tree().change_scene("res://Levels/Desert_House.tscn")
	
	if quitButton.is_pressed():
		get_tree().quit()
