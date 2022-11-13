extends Control

var multiSpawn = Globals.multiSpawn

onready var changeSpawnMode = $itemContainer/changeSpawnMode/Label
onready var backButton = $itemContainer/backButton/Label


func _ready():
	
	self.visible = false
	
	if Globals.multiSpawn:
		changeSpawnMode.text = "SPAWN: AUTO"
	else:
		changeSpawnMode.text = "SPAWN: SEMI"


func _physics_process(delta):
	
	
	
	if $itemContainer/changeSpawnMode.is_hovered() and Input.is_action_just_pressed("shoot"):
		if Globals.multiSpawn:
			changeSpawnMode.text = "SPAWN: SEMI"
			Globals.multiSpawn = false
		else:
			changeSpawnMode.text = "SPAWN: AUTO"
			Globals.multiSpawn = true
