extends CanvasLayer

var _plant_sprite
var _fading_in := false
var _fading_out := false
var _waiting := false
var _time_in_phase := 0.0
var _time_for_fade := 2.0
var _time_for_wait := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plant_sprite = get_node("Container")
	_plant_sprite.hide()
	
func _process(delta) -> void:
	if _fading_in:
		_time_in_phase = min(_time_in_phase + delta, _time_for_fade)
		_set_fade(_time_in_phase / _time_for_fade)
		if (_time_in_phase == _time_for_fade):
			_start_waiting()
	elif _fading_out:
		_time_in_phase = min(_time_in_phase + delta, _time_for_fade)
		_set_fade(1.0 - _time_in_phase / _time_for_fade)
		if (_time_in_phase == _time_for_fade):
			_fading_out = false
			_plant_sprite.hide()
	
func start_fade_in() -> void:
	_time_in_phase = 0.0
	_fading_out = false
	_waiting = false
	_fading_in = true
	_plant_sprite.show()

func _start_waiting() -> void:
	_time_in_phase = 0.0
	_fading_in = false
	_fading_out = false
	_waiting = true

func start_fade_out() -> void:
	if !_waiting:
		return
	
	_time_in_phase = 0.0
	_waiting = false
	_fading_in = false
	_fading_out = true

func _set_fade(alpha) -> void:
	_plant_sprite.modulate = Color(1, 1, 1, alpha)
