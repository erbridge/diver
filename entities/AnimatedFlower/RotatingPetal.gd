extends Sprite

export var _offset := 0.0
export var _strength := 1.0
export var _speed := 0.25
var _timeSpent = 0
onready var _main = get_tree().get_root().get_node("Main")
var _screensize

export var _spawnDelay := 0.0

func _ready() -> void:
	_update_position()
	
func _update_position() -> void:
	_screensize = get_viewport().get_visible_rect().size
	var position = Vector2.ZERO
	position.x = _screensize.x / 2.0
	position.y = _screensize.y / 2.0
	set_position(position)

func _process(var delta) -> void:
	_timeSpent += delta
	set_rotation(sin((_timeSpent + _offset) * _speed) * _strength)
	
	if get_viewport().get_visible_rect().size.x != _screensize.x:
		_update_position()

func _input(event):
	if !_main.get_plant_ui().is_waiting():
		return
		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		get_tree().get_root().get_node("Main").get_plant_ui().start_fade_out()
		var pos = get_global_mouse_position()
		pos.x -= _screensize.x / 2.0
		pos.y -= _screensize.y / 2.0
		get_tree().get_root().get_node("Main").set_plant_with_scale(pos, 4.0)
