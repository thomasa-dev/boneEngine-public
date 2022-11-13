extends Spatial



func _ready():
			# loading the scenes to spawn in
	var bottleObject = preload("res://assets/bottle.tscn")

	# creating the instances
	var bottleInstance = bottleObject.instance()
	add_child(bottleInstance)
