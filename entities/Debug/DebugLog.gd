extends Label

onready var character

func _ready():
	character = get_tree().root.get_node("Main/Character")
	
func _input(event) -> void:
	var tpos = get_canvas_transform().affine_inverse().xform(event.position)
	var mpos = get_global_mouse_position()
	text = "t: " + str(tpos.x) + ", " + str(tpos.y) + "\r\n" + "m: " + str(mpos.x) + ", " + str(mpos.y)	 
	
