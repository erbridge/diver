extends Area2D

var rnd = RandomNumberGenerator.new()
var time_spent = 0.0
var center_pos = Vector2.ZERO

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
	var randX = 0.0##rnd.randf_range(0, 3000) - 1500
	var randY = rnd.randf_range(0, 150) + 1400
	center_pos = Vector2(randX, randY)

func _process(delta) -> void:
	time_spent += delta
	var xWidth = 350.0 + sin(time_spent * 0.8) * 50.0
	var yWidth = 180.0 + sin(time_spent) * 30.0
	position.x = center_pos.x + sin(time_spent * 1.5) * xWidth
	position.y = center_pos.y + cos(time_spent * 0.5) * yWidth + sin(time_spent) * 50.0
