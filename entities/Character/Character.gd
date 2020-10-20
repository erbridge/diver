extends Node2D
# A character node to implement movement based on touch input.
#
# The character uses acceleration and drag, both linear and rotational, to
# govern its movement. It accelerates towards the current screen position of
# the touch input, while it's still touched, and carries forwards its momentum
# when the input ends, with no further acceleration.
#
# The character only ever linearly accelerates in its forwards direction, and
# it rotates to point towards its destination as it moves. The linear
# acceleration is at its maximum when the character is pointed directly at its
# target, and 0 when pointed directly away, causing tit to speed up as it
# rotates towards the target, and slow down as it overshoots it. The rotational
# acceleration follows a similar pattern, allowing it to overshoot, but
# self-correct, with an added factor, that it's rotation is slower the faster
# it's moving.
#
# Drag on the character is proportional to the square of its velocity.

export var acceleration_factor := 10.0
export var drag_factor := 0.05
export var movement_accuracy := 20.0

export var max_rotation_acceleration_factor := 100.0
export var min_rotation_acceleration_factor := 10.0
export var rotation_drag_factor := 2.0
export var rotation_accuracy := 10.0

onready var _main = get_parent() 

var _velocity := Vector2.ZERO
var _rotation_velocity := 0.0
var _move_to_target := false
var _adjust_lighting := false
var _time_to_adjust := 2.0
var _time_spent_adjusting := 0.0
var _max_darkness := 0.4
var _bob_time := 0.0
var _bob_strength := 0.75

var _unbobbed_position
var _is_bright_world = false
var _touchPos

## _unhandled_input if we don't wanna capture UI events
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_move_to_target = (event as InputEventScreenTouch).pressed
	_touchPos = get_canvas_transform().affine_inverse().xform(event.position)

func _physics_process(delta: float) -> void:
	_move(delta)
	_updateTint()

var _did_reach_min_rotation = false

func _move(delta: float) -> void:
	var acceleration = _calculate_acceleration(_touchPos)
	var rotation_acceleration = _calculate_rotation_acceleration(_touchPos)
	var speed_modifier = 1
	if _main.is_darkmode:
		speed_modifier = 0.5

	_velocity += delta * acceleration
	_rotation_velocity += delta * rotation_acceleration

	translate(delta * _velocity * speed_modifier)
	position.y = max(-50.0, position.y)
	if (_main.is_darkmode && position.x < -50):
		position.x = -50
	elif (_main.is_darkmode && position.x > 50):
		position.x = 50
	rotate(delta * _rotation_velocity)
	
	if ((_main.is_darkmode && position.y < 7500 && rotation < 0) ||
	   (_main.is_darkmode && position.y < 7500 && rotation > 2) ||
	   (_main.is_darkmode && position.y < 7500 && rotation < 1 && _did_reach_min_rotation)):
		var targetPos = _touchPos
		targetPos.x = 0
		rotation_acceleration = _calculate_rotation_acceleration(targetPos)
		_rotation_velocity += delta * rotation_acceleration
		rotate(delta * _rotation_velocity)

func _calculate_acceleration(var target) -> Vector2:
	var acceleration = drag_factor * _velocity.length_squared() * -_velocity.normalized()

	if _move_to_target:
		var position_delta = _get_position_delta(target)

		if position_delta.length_squared() > pow(movement_accuracy, 2):
			var forwards = transform.basis_xform(Vector2.RIGHT).normalized()
			var forwards_acceleration = acceleration_factor * forwards.dot(position_delta)

			if forwards_acceleration > 0:
				acceleration += forwards_acceleration * forwards
				
	return acceleration

func _calculate_rotation_acceleration(var target) -> float:
	var acceleration = rotation_drag_factor * pow(_rotation_velocity, 2) * -sign(_rotation_velocity)

	if _move_to_target:
		var position_delta = _get_position_delta(target)
		var rotation_delta = _get_rotation_delta(target)

		if (
			position_delta.length_squared() > pow(movement_accuracy, 2)
			and abs(rotation_delta) > deg2rad(rotation_accuracy)
		):
			acceleration_factor = max(
				max_rotation_acceleration_factor / max(_velocity.length(), 1),
				min_rotation_acceleration_factor
			)

			acceleration += acceleration_factor * rotation_delta
	return acceleration

func _get_position_delta(var target) -> Vector2:
	var pos = target
	##pos.y = max(0.0, pos.y)
	return pos - global_position

func _get_rotation_delta(var target) -> float:
	return get_angle_to(target)

func _updateTint() -> void:
	var darkness = _max_darkness
	if _is_bright_world:
		darkness = 0.6
	var brightness = max(darkness, min(1.0, 1 - global_position.y/6000))
	get_node("Sprite").self_modulate = Color(brightness, brightness, brightness, 1)
	
func _process(delta) -> void:
	if (_adjust_lighting):
		_time_spent_adjusting += delta
		var progress = min(1.0, _time_spent_adjusting / _time_to_adjust)
		_max_darkness = 0.4 + 0.2 * progress
		if (progress == 1.0):
			_adjust_lighting = false
	if (!Input.is_action_pressed("mouse_0_held")):
		_bob_time += delta
		do_bob()

func brighten_world() -> void:
	_adjust_lighting = true

func do_bob() -> void:
	if (position.y <= 75):
		var offset = sin(_bob_time * 1.5) * _bob_strength
		position.y += offset
	else:
		var offset = sin(_bob_time * 1) * _bob_strength * 0.75
		position.x += offset
	
