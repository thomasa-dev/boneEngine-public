extends Spatial

var Map_Resource : Resource
var Resource_Name = "Mod_Resource"
var mod_manager_name = "boneLoader" # Replace this with the mod managers name
var mod_file_name = "marrowsSandbox" # replace this with the mod name
var mod_file_author = "marrow" # replace this with the mod author
var folder_name = mod_file_author + mod_file_name

var mod_file
var mod_manager
var mod_name
var mod_author
var mod_version

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
var scriptsDir = Directory.new()


var customScripts = []
var spawnableObjects = []
var objectNames = []




func _ready():
	
	print(str(gameLocation) + "/" + mod_manager_name + "/" + mod_file_author + "." + mod_file_name + "/" + Resource_Name + ".tres")
	mod_file = load(str(gameLocation) + "/" + mod_manager_name + "/" + mod_file_author + "." + mod_file_name + "/" + Resource_Name + ".tres") # getting the mods resource
	
	# settings the mods variables
	mod_manager = mod_file.get("mod_manager")
	mod_name = mod_file.get("mod_name")
	mod_author = mod_file.get("mod_author")
	mod_version = mod_file.get("mod_version")
	gameDirectory.open(gameLocation)
	
	Globals.objectCount -= 1
	
	# adding the base assets to the spawnableObjects array
	spawnableObjects = [
		bottleObject,
		tableObject,
		crateObject,
		targetObject
	]
	
	for object in spawnableObjects:
		Globals.customItems.append(object)
	
	objectNames = [
		"Bottle",
		"Table",
		"Crate",
		"Target"
	]
	
	print("Current spawnable object count : " + str(objectCount + 1))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("itemSelectionUp"):
		if selectedObject < Globals.objectCount:
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
	var spawnableInstance = Globals.customItems[object].instance()

	add_child(spawnableInstance)
	spawnableInstance.global_transform.origin = playerHand.global_transform.origin
