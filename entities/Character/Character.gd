extends Node2D

var move_to_target = false
var target = Vector2()

func _input(event):
  if event is InputEventScreenTouch:
    move_to_target = event.pressed
    target = event.position

  if event is InputEventScreenDrag:
    target = event.position

func _process(_delta):
  if move_to_target:
    look_at(target)
    position = target
