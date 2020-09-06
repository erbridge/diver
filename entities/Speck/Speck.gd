extends Area2D

func _on_Speck_area_entered(area):
	print("collected a speck")
	if (area.get_name() == "Character"):
		var main = get_tree().get_root().get_node("Main")
		main.get_plant_ui().start_fade_in()
		main.set_plant(position)
		for child in get_children():
			child.queue_free()
		queue_free()
