extends Node2D

export (float) var acceleration_factor = 10
export (float) var drag_factor = 0.05
export (float) var movement_accuracy = 20

export (float) var max_rotation_acceleration_factor = 100
export (float) var min_rotation_acceleration_factor = 10
export (float) var rotation_drag_factor = 2
export (float) var rotation_accuracy = 10

var velocity = Vector2.ZERO
var rotation_velocity = 0

var move_to_target = false


func move(delta: float) -> void:
	var acceleration = drag_factor * velocity.length_squared() * -velocity.normalized()
	var rotation_acceleration = (
		rotation_drag_factor
		* pow(rotation_velocity, 2)
		* -sign(rotation_velocity)
	)

	if move_to_target:
		var target_position = get_global_mouse_position()

		var position_diff = target_position - global_position
		var rotation_diff = get_angle_to(target_position)

		if position_diff.length_squared() > pow(movement_accuracy, 2):
			if abs(rotation_diff) > deg2rad(rotation_accuracy):
				rotation_acceleration += (
					max(
						max_rotation_acceleration_factor / max(velocity.length(), 1),
						min_rotation_acceleration_factor
					)
					* rotation_diff
				)

			var forwards = transform.basis_xform(Vector2.RIGHT).normalized()
			var forwards_acceleration = forwards.dot(acceleration_factor * position_diff)

			if forwards_acceleration > 0:
				acceleration += forwards_acceleration * forwards

	velocity += delta * acceleration
	rotation_velocity += delta * rotation_acceleration

	translate(delta * velocity)
	rotate(delta * rotation_velocity)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		move_to_target = (event as InputEventScreenTouch).pressed


func _physics_process(delta: float) -> void:
	move(delta)
