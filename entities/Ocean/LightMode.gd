extends Node2D

var _timeToFade = 2.0
var _timeSpent = 0.0
var _doFadeIn = false

func _ready() -> void:
	modulate.a = 0.0

func _process(delta) -> void:
	if _doFadeIn:
		_timeSpent += delta
		var progress = min(_timeSpent / _timeToFade, 1.0)
		modulate.a = progress
		if (progress == 1.0):
			_doFadeIn = false

func start_fade() -> void:
	_doFadeIn = true
