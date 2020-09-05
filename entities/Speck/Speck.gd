extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Speck_area_entered(area):
	print("collected a speck")
	if (area.get_name() == "Character"):
		get_tree().get_root().get_node("Main").get_plant_ui().start_fade_in()
		self.hide()
