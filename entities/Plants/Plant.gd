extends Sprite

var _is_growing = false
var _accumulated_scale = 0
var _growth_speed = 0.2

func _ready() -> void:
	scale = Vector2.ZERO
	_is_growing = true
	
func _process(delta) -> void:
	if not _is_growing:
		return
	
	_accumulated_scale += delta * _growth_speed
	if (_accumulated_scale >= 1.0):
		_accumulated_scale = 1.0
		_is_growing = false
		
	scale = Vector2.ONE * _accumulated_scale

func save() -> Dictionary:
	var dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return dict
