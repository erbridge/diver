extends Node2D

var _plantUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plantUI = get_node("PlantUI")

func get_plant_ui() -> Node2D:
	return _plantUI
