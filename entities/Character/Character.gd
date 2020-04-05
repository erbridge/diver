extends Node2D

var move_to_target = false
var target = transform

func _input(event):
  if event is InputEventScreenTouch:
    move_to_target = event.pressed

  if event is InputEventScreenTouch or event is InputEventScreenDrag:
    target = Transform2D(event.position.angle_to_point(position), event.position)

func _process(_delta):
  if move_to_target:
    transform = transform.interpolate_with(target, 0.1)
