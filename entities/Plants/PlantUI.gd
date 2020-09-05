extends CanvasLayer

var _plant_sprite
var _fading_in := false
var _fading_out := false
var _time_in_phase := 0.0
var _time_for_phase := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plant_sprite = get_node("MarginContainer/TextureRect")
	
func _process(delta) -> void:
	if _fading_in:
		_time_in_phase += delta
		_set_fade(_time_in_phase / _time_for_phase)
	elif _fading_out:
		_time_in_phase += delta
		_set_fade(1.0 - _time_in_phase / _time_for_phase)
	
func start_fade_in() -> void:
	_fading_out = false
	_fading_in = true

func start_fade_out() -> void:
	_fading_in = false
	_fading_out = true

func _set_fade(alpha) -> void:
	_plant_sprite.self_modulate = Color(1, 1, 1, alpha)
