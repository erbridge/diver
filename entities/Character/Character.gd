extends Node2D
# A character node to implement movement based on touch input.
#
# The character uses acceleration and drag, both linear and rotational, to
# govern its movement. It accelerates towards the current screen position of
# the touch input, while it's still touched, and carries forwards its momentum
# when the input ends, with no further acceleration.

# The character only every linearly accelerates in its forwards direction, and
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

var _velocity := Vector2.ZERO
var _rotation_velocity := 0.0
var _move_to_target := false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_move_to_target = (event as InputEventScreenTouch).pressed


func _physics_process(delta: float) -> void:
	_move(delta)


func _move(delta: float) -> void:
	var acceleration = drag_factor * _velocity.length_squared() * -_velocity.normalized()
	var rotation_acceleration = (
		rotation_drag_factor
		* pow(_rotation_velocity, 2)
		* -sign(_rotation_velocity)
	)

	if _move_to_target:
		var target_position = get_global_mouse_position()

		var position_diff = target_position - global_position
		var rotation_diff = get_angle_to(target_position)

		if position_diff.length_squared() > pow(movement_accuracy, 2):
			if abs(rotation_diff) > deg2rad(rotation_accuracy):
				rotation_acceleration += (
					max(
						max_rotation_acceleration_factor / max(_velocity.length(), 1),
						min_rotation_acceleration_factor
					)
					* rotation_diff
				)

			var forwards = transform.basis_xform(Vector2.RIGHT).normalized()
			var forwards_acceleration = acceleration_factor * forwards.dot(position_diff)

			if forwards_acceleration > 0:
				acceleration += forwards_acceleration * forwards

	_velocity += delta * acceleration
	_rotation_velocity += delta * rotation_acceleration

	translate(delta * _velocity)
	rotate(delta * _rotation_velocity)
