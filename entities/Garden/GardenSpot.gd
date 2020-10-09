extends Sprite
class_name GardenSpot

var _plant

func init () -> void:
	var plants = get_tree().get_nodes_in_group("plants")
	for i in range (0, plants.size()):
		var nodePos = get_global_position()
		var plantPos = plants[i].get_global_position()
		if (nodePos.x >= plantPos.x - 0.001 && nodePos.x <= plantPos.x + 0.001 &&
			nodePos.y >= plantPos.y - 0.001 && nodePos.y <= plantPos.y + 0.001):
			add_plant(plants[i])
			return;
	
func remove_plant(var plant) -> void:
	_plant = null
	self_modulate.a = 1.0
	plant.set_spot(null)
	
func add_plant(var plant) -> void:
	_plant = plant
	self_modulate.a = 0.0
	plant.set_spot(self)

func has_plant() -> bool:
	return (_plant != null)
