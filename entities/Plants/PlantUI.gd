extends CanvasLayer

var _plant_sprite
var _fading_in = false
var _fading_out = false
var _waiting = false
var _time_in_phase = 0.0
export var _time_for_fade_in := 2.0
export var _time_for_fade_out := 2.0
export var _time_for_wait := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plant_sprite = get_node("Container")
	_plant_sprite.hide()
	
func _process(delta) -> void:
	if _fading_in:
		_time_in_phase = min(_time_in_phase + delta, _time_for_fade_in)
		_set_fade(_time_in_phase / _time_for_fade_in)
		if (_time_in_phase >= _time_for_fade_in - 0.001):
			_start_waiting()
	elif _fading_out:
		_time_in_phase = min(_time_in_phase + delta, _time_for_fade_out)
		_set_fade(1.0 - _time_in_phase / _time_for_fade_out)
		if (_time_in_phase >= _time_for_fade_out - 0.001):
			_fading_out = false
			_plant_sprite.hide()
	
func start_fade_in() -> void:
	_time_in_phase = 0.0
	_fading_out = false
	_waiting = false
	_fading_in = true
	_plant_sprite.show()

func _start_waiting() -> void:
	if !_fading_in:
		return
		
	_time_in_phase = 0.0
	_fading_in = false
	_fading_out = false
	_waiting = true

func start_fade_out() -> void:
	if !_waiting:
		return
	if _plant_sprite.modulate.a == 0.0:
		return
	
	_time_in_phase = 0.0
	_waiting = false
	_fading_in = false
	_fading_out = true

func is_waiting() -> bool:
	return _waiting

func _set_fade(alpha) -> void:
	_plant_sprite.modulate = Color(1, 1, 1, alpha)
