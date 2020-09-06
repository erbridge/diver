extends Node2D

var _plantUI
onready var _plant = preload("res://entities/Plants/Plant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plantUI = get_node("PlantUI")

func get_plant_ui() -> Node2D:
	return _plantUI

func set_plant(pos) -> void:
	var p = _plant.instance()
	add_child(p)
	p.position = pos
