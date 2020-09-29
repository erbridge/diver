extends Sprite

export var _offset := 0.0
export var _strength := 1.0
export var _speed := 0.25
var _timeSpent = 0

export var _spawnDelay := 0.0

func _ready() -> void:
	var screensize = get_viewport().get_visible_rect().size
	var position = Vector2.ZERO
	position.x = screensize.x / 2.0
	position.y = screensize.y / 2.0
	set_position(position)

func _process(var delta) -> void:
	_timeSpent += delta
	set_rotation(sin((_timeSpent + _offset) * _speed) * _strength)
