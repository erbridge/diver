extends Node2D

var _plantUI
var _character
var _garden
var _darkOcean
var _lightSky
var _darkSky
var _lightForeground
var is_darkmode := true
var _has_inited_garden = false
onready var _plant = preload("res://entities/Plants/Plant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plantUI = get_node("PlantUI")
	_darkOcean = get_node("WorldBackground/Ocean/DarkMode")
	_lightSky = get_node("WorldBackground/Sky/LightMode")
	_darkSky  = get_node("WorldBackground/Sky/DarkMode")
	_lightForeground = get_node("WorldForeground/OceanFloor/LightMode")
	_character = get_node("Character")
	_garden = get_node("Garden")
	is_darkmode = true
	load_game()
	
func _process(var delta) -> void:
	if !_has_inited_garden:
		_has_inited_garden = true
		_garden.init()

func brighten_world() -> void:
	_darkOcean.start_fade()
	_lightSky.start_fade()
	_darkSky.start_fade()
	_lightForeground.start_fade()
	_character.brighten_world()
	_garden.appear()
	is_darkmode = false

func get_plant_ui() -> Node2D:
	return _plantUI

func set_plant(pos) -> void:
	var p = _plant.instance()
	add_child(p)
	p.position = pos
	save_game()
	
func set_plant_with_scale(pos, scale) -> void:
	var p = _plant.instance()
	add_child(p)
	p.position = pos
	p.start_new_plant()
	save_game()

func save_game() -> void:
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		# Call the node's save function.
		var node_data = node.save()
		
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	
	save_game.close()

func load_game() -> void:
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.add_to_group("persist")
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		if (node_data.has("creation_time")):
			new_object.creation_time = node_data["creation_time"]

		# Now we set the remaining variables.
#		for i in node_data.keys():
#			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#				continue
#			new_object.set(i, node_data[i])

	save_game.close()
