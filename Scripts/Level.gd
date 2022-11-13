extends Spatial

var modSupport = Globals.modSupport
var multiSpawn = Globals.multiSpawn
onready var playerHand = $Player/Head/Camera/HoldPosition
onready var objectLabel = $currentItem
var selectedObject = 0
var objectCount = 4

# loading the scenes to spawn in - NOTE: These are ones that are added manually
var bottleObject = load("res://Spawnables/Bottle.tscn")
var tableObject = load("res://Spawnables/Table.tscn")
var crateObject = load("res://Spawnables/WoodenCrate.tscn")
var targetObject = load("res://Spawnables/Target.tscn")

# for built-in or modpack assets here's the format:
# var [object name]Object = load("[res:// path for the .tscn file]")


var gameLocation = OS.get_executable_path().get_base_dir()
var dir = Directory.new()
var gameDirectory = Directory.new()
var scriptDirectory = Directory.new()

var customScripts = []
var spawnableObjects = []
var objectNames = []




func _ready():
	gameDirectory.open(gameLocation)
	
	objectCount -= 1
	
	# adding the base assets to the spawnableObjects array
	spawnableObjects = [
		bottleObject,
		tableObject,
		crateObject,
		targetObject
	]
	
	objectNames = [
		"Bottle",
		"Table",
		"Crate",
		"Target"
	]
	
	if Globals.modSupport:
		loadItems(str(gameLocation) + "/CustomItems")
	
	print("Current spawnable object count : " + str(objectCount + 1))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("itemSelectionUp"):
		if selectedObject < objectCount:
			selectedObject += 1
			objectLabel.text = objectNames[selectedObject]
			print("Object switched up")
	elif Input.is_action_just_pressed("itemSelectionDown"):
		if selectedObject > 0:
			selectedObject -= 1
			objectLabel.text = objectNames[selectedObject]
			print("Object switched down")
	
	if Globals.multiSpawn:
		if Input.is_action_pressed("spawnBottle"):
			spawnObject(selectedObject)
	elif not Globals.multiSpawn:
		if Input.is_action_just_pressed("spawnBottle"):
			spawnObject(selectedObject)

func spawnObject(object):

	# creating the instances
	var spawnableInstance = spawnableObjects[object].instance()

	add_child(spawnableInstance)
	spawnableInstance.global_transform.origin = playerHand.global_transform.origin

### CUSTOM ITEM LOADING ###
func loadItems(path):
	var loadingDir = Directory.new()
	if loadingDir.open(path) == OK:
		print("Starting I T E M scan")
		loadingDir.list_dir_begin()
		
		var currentFile = loadingDir.get_next()
		
		while currentFile != "":
			
			if currentFile.begins_with("."):
				print("Found invalid or parent folder/file! Skipping.")
			
			if loadingDir.current_is_dir():
				print("Found folder: " + currentFile)
			
			elif currentFile.ends_with(".tscn"):
				print("Found item: " + currentFile)
				var currentObject = load(str(gameLocation) + "/CustomItems/" + currentFile)
				var currentObjectName = currentFile.replace(".tscn", "")
				
				objectNames.append(currentObjectName)
				spawnableObjects.append(currentObject)
				objectCount += 1
			
			else:
				print("Found other: " + currentFile)

