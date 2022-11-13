extends Spatial

export var exporting : bool = false
export var massSpawn : bool = false
onready var playerHand = $Player/Head/Camera/HoldPosition
onready var objectLabel = $RichTextLabel
var selectedObject = 0
var objectCount = 4

# loading the scenes to spawn in - NOTE: These are ones that are added manually
var bottleObject = load("res://assets/bottle.tscn")
var tableObject = load("res://assets/Table.tscn")
var crateObject = load("res://assets/WoodenCrate.tscn")
var targetObject = load("res://assets/Target.tscn")

# for built-in or modpack assets here's the format:
# var [object name]Object = load("[res:// path for the .tscn file]")


var location = OS.get_executable_path().get_base_dir()

var spawnableObjects = []
var objectNames = []




func _ready():
	
	
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
	
	if exporting:
		var files = []
		var dir = Directory.new()
		dir.open(str(location)+"/CustomItems")
		dir.list_dir_begin()
			
		for n in range(10):
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				var newObject = load(str(location)+"/CustomItems/"+str(file))
				spawnableObjects.append(newObject)
				print(newObject)
				var objectName = file.replace(".tscn", "")
				objectNames.append(objectName)
				objectCount += 1
		dir.list_dir_end()
	
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
	
	if massSpawn:
		if Input.is_action_pressed("spawnBottle"):
			spawnObject(selectedObject)
	elif not massSpawn:
		if Input.is_action_just_pressed("spawnBottle"):
			spawnObject(selectedObject)

func spawnObject(object):

	# creating the instances
	var spawnableInstance = spawnableObjects[object].instance()

	add_child(spawnableInstance)
	spawnableInstance.global_transform.origin = playerHand.global_transform.origin
