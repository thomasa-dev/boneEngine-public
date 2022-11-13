extends Control


var mapCount = -1
var levelsDir = Directory.new()
var scriptsDir = Directory.new()
var gameDirectory = Directory.new()

onready var modSupport = Globals.modSupport
onready var gameLocation = OS.get_executable_path().get_base_dir()

# All button variables
onready var quitButton = $buttonContainers/quitButton
onready var sandboxButton = $buttonContainers/sandboxButton
onready var settingsButton = $buttonContainers/settingsButton
onready var switchingButton = $buttonContainers/switchingButton
onready var playCustomLevelButton = $buttonContainers/playLevelButton

onready var settingsMenu = $buttonContainers/Settings
onready var settingsBackButton = $buttonContainers/Settings/itemContainer/backButton

onready var seperateUIObjects = [ # put everything here that you want to be hidden when the settings menu is shown
	$logoThingy,
	quitButton,
	sandboxButton,
	settingsButton,
	playCustomLevelButton,
	switchingButton
]

var customScriptNames = []
var customScripts = []
var customLevels = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	mapCount = -1
	
	gameDirectory.open(str(gameLocation))
	
	if not modSupport:
		$buttonContainers/switchingButton/Label.text = "No mod support!"
	
	if Globals.modSupport:
		pass
		# loadScripts(str(gameLocation) + "/CustomMaps/Scripts")
		# loadMaps(str(gameLocation) + "/CustomMaps")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sandbox level button
	if sandboxButton.is_pressed():
		self.visible = false
		get_tree().change_scene("res://Levels/Desert_House.tscn")
	
	# Settings menu button
	if settingsButton.is_pressed():
		Globals.showMenu($buttonContainers/Settings, seperateUIObjects)
	
	# Quit game button
	if quitButton.is_pressed():
		get_tree().quit()
	
	if settingsBackButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		Globals.hideMenu($buttonContainers/Settings, seperateUIObjects)
	
	if switchingButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		if modSupport and gameDirectory.dir_exists("CustomMaps"):
			if Globals.currentSelectedMap < mapCount:
				Globals.currentSelectedMap += 1
				print("New map")
				print(Globals.currentSelectedMap)
				print(Globals.customLevels[Globals.currentSelectedMap])
				$buttonContainers/switchingButton/Label.text = Globals.customLevelNames[Globals.currentSelectedMap]
			else:
				Globals.currentSelectedMap = 0
				print("Reset map")
				print(Globals.currentSelectedMap)
				print(Globals.customLevels[Globals.currentSelectedMap])
				$buttonContainers/switchingButton/Label.text = Globals.customLevelNames[Globals.currentSelectedMap]
	
	if playCustomLevelButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		if modSupport:
			Globals.PrintSuc("Loading level file: " + str(Globals.customLevels[Globals.currentSelectedMap]))
			get_tree().change_scene_to(Globals.customLevels[Globals.currentSelectedMap])





### SCRIPT LOADING ###
func loadScripts(path):
	var loadingDir = Directory.new()
	
	if loadingDir.open(path) == OK:
		
		loadingDir.list_dir_begin() # starting the scan for the files
		print("Starting S C R I P T scan") # logging that the scan has started
			
		var currentFile = loadingDir.get_next() # making a variable called currentFile which is the file that has been found
		while currentFile != "": # if the currentFile variable isn't empty
			if currentFile.begins_with("."):
				pass
				
			elif loadingDir.current_is_dir():
				print("Found directory: " + currentFile)
			
			elif not loadingDir.current_is_dir():
				if currentFile.ends_with(".gd"):
					print("Found script: " + currentFile)
					
					customScripts.append(str(gameLocation) + "/CustomMaps/Scripts/" + currentFile) # adding the files location to the customScripts array
					customScriptNames.append(currentFile.replace(".gd", "")) # adding the files name to the customScriptNames array
			
			else:
				print("Found other file: " + currentFile)
				
			
			currentFile = loadingDir.get_next() # getting the next file



### MAP LOADING ###
func loadMaps(path):
	var loadingDir = Directory.new()
	
	if loadingDir.open(path) == OK:
		
		loadingDir.list_dir_begin() # starting the scan for the files
		print("Starting M A P scan") # logging that the scan has started
		
		var currentFile = loadingDir.get_next() # making a variable called currentFile which is the file that has been found
		while currentFile != "": # if the currentFile variable isn't empty
			if currentFile.begins_with("."):
				pass
			
			elif loadingDir.current_is_dir(): # if there's another directory inside "path" directory
				print("Found directory: " + currentFile)
			
			elif not loadingDir.current_is_dir(): # if currentFile is a file
				if currentFile.ends_with(".tscn"): # if it's a scene
					print("Found map: " + currentFile)
					
					Globals.customLevels.append(str(gameLocation) + "/CustomMaps/" + currentFile) # adding the map to the loadable maps array
					Globals.customLevelNames.append(currentFile.replace(".tscn", "")) # adding the maps name to the loadable map names array
					mapCount += 1
			
			else: # if there's a different file
				print("Found other file: " + currentFile)
			
			currentFile = loadingDir.get_next() # getting the next file
				
		$buttonContainers/switchingButton/Label.text = Globals.customLevelNames[Globals.currentSelectedMap]
		
	else: # if the map folder doesn't exist
		$buttonContainers/switchingButton/Label.text = "No Map Folder Found!"
