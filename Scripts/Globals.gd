extends Node

###### Game options ######
var currentSelectedMap = 0
var modSupport = true
var multiSpawn = false
var isPaused = false

var customLevels = []
var customLevelNames = []
var customItems = []

var objectCount = 4

###### Gun Options ######
var gunFireMode = 0
var gunFireTypes = [
	"Semi-Auto",
	"Full-Auto"
]
var maxFireMode = 1


func PrintSuc(text):
	Print.line(Print.GREEN, text)

func PrintErr(text):
	Print.line(Print.RED, text)


### Menu Functions ###

func showMenu(menu, parentMenu): # for showing menus
	menu.visible = true
	for obj in parentMenu:
		obj.visible = false

func hideMenu(menu, parentMenu): # for hiding menus
	menu.visible = false
	for obj in parentMenu:
		obj.visible = true
