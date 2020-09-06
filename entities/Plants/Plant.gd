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
