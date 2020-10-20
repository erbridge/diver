extends Node2D

export var _fadeOut := false
var _timeToFade = 2.0
var _timeSpent = 0.0
var _doFade = false

func _ready() -> void:
	if _fadeOut:
		modulate.a = 1.0
	else:
		modulate.a = 0.0

func _process(delta) -> void:
	if _doFade:
		_timeSpent += delta
		if _fadeOut:
			var progress = max(1.0 - _timeSpent / _timeToFade, 0.0)
			modulate.a = progress
			if (_timeSpent >= _timeToFade):
				_doFade = false
		else:
			var progress = min(_timeSpent / _timeToFade, 1.0)
			modulate.a = progress
			if (_timeSpent >= _timeToFade):
				_doFade = false

func start_fade() -> void:
	_doFade = true
	_timeSpent = 0.0
