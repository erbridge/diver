extends Area2D

var rnd = RandomNumberGenerator.new()

func _on_Speck_area_entered(area):
	print("collected a speck")
	if (area.get_name() == "Character"):
		var main = get_tree().get_root().get_node("Main")
		main.get_plant_ui().start_fade_in()
		main.set_plant(position)
		for child in get_children():
			child.queue_free()
		queue_free()

func _ready() -> void:
	rnd.seed = hash(OS.get_system_time_msecs())
	var randX = rnd.randf_range(0, 3000) - 1500
	var randY = rnd.randf_range(0, 150) + 1800
	position = Vector2(randX, randY)
