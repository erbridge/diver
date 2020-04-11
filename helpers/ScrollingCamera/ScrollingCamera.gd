extends Camera2D
# A `Camera2D` that scrolls when its target nears its edges.
#
# The camera position updates during `_process`.

const SCROLL_FACTOR := 200

export var target := NodePath()
export var margin := 150.0

onready var _target_node: Node2D = get_node(target)


func _process(delta: float) -> void:
	if current:
		_ensure_target_visibility(delta)


func _ensure_target_visibility(delta: float) -> void:
	if not _target_node:
		return

	var viewport_rect = get_viewport_rect()
	var inner_limits = viewport_rect.grow(-margin)

	var target_screen_transform = _target_node.get_global_transform_with_canvas()
	var target_screen_position = target_screen_transform.get_origin()

	if inner_limits.has_point(target_screen_position):
		return

	if viewport_rect.grow_individual(-margin, 0, 0, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.RIGHT

	if viewport_rect.grow_individual(0, -margin, 0, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.DOWN

	if viewport_rect.grow_individual(0, 0, -margin, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.LEFT

	if viewport_rect.grow_individual(0, 0, 0, -margin).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.UP
