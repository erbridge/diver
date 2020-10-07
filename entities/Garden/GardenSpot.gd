extends Sprite
class_name GardenSpot

var _plant

func init () -> void:
	var plants = get_tree().get_nodes_in_group("plants")
	for i in range (0, plants.size()):
		var nodePos = get_global_position()
		var plantPos = plants[i].get_global_position()
		if (nodePos.x == plantPos.x && nodePos.y == plantPos.y):
			add_plant(plants[i])
			return;
	
func remove_plant(var plant) -> void:
	_plant = null
	self_modulate.a = 1.0
	
func add_plant(var plant) -> void:
	add_child(plant)
	_plant = plant
	self_modulate.a = 0.0
