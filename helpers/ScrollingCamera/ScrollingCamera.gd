extends Camera2D
# A `Camera2D` that scrolls when its target nears its edges.
#
# The camera position updates during `_process`.

onready var _diver = get_parent().get_node("Character")
const SCROLL_FACTOR := 800

export var target := NodePath()
export var margin := 300.0

onready var _target_node: Node2D = get_node(target)

func _process(delta: float) -> void:
	if current:
		_update_zoom_level()
		_restrict_to_allowed_area()
		_ensure_target_visibility(delta)

func _ensure_target_visibility(delta: float) -> void:
	if not _target_node:
		return
		
	var vportsize = get_viewport().get_visible_rect().size
	margin = min(vportsize.x, vportsize.y) * 0.3

	var viewport_rect = get_viewport_rect()
	var adjusted_margin = -margin * min(2, max(0.75, zoom.x))
	var inner_limits = viewport_rect.grow(adjusted_margin)

	var target_screen_transform = _target_node.get_global_transform_with_canvas()
	var target_screen_position = target_screen_transform.get_origin()

#	if inner_limits.has_point(target_screen_position):
#		return

	if viewport_rect.grow_individual(adjusted_margin, 0, 0, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.RIGHT

	if viewport_rect.grow_individual(0, adjusted_margin * 2.5, 0, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.DOWN

	if viewport_rect.grow_individual(0, 0, adjusted_margin, 0).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.LEFT

	if viewport_rect.grow_individual(0, 0, 0, adjusted_margin * 1.5).has_point(target_screen_position):
		position += SCROLL_FACTOR * delta * Vector2.UP

func _update_zoom_level() -> void:
	var pos = _diver.global_position.y
	var newZoom = lerp(0.5, 2, max(min(pos/6000, 1), 0))
	zoom = Vector2(newZoom, newZoom)

func _restrict_to_allowed_area() -> void:
	
	var size = get_viewport_rect().size
	
	var maxTop    = - 600 + size.y * zoom.y * 0.5
	var maxBottom =  9050 - size.y * zoom.y * 0.5
	var maxLeft   = -2000 + size.x * zoom.x * 0.5
	var maxRight  =  2000 - size.x * zoom.x * 0.5
	
	if (position.y < maxTop):
		position.y = maxTop
	elif (position.y > maxBottom):
		position.y = maxBottom
		
	if (position.x < maxLeft):
		position.x = maxLeft
	elif (position.x > maxRight):
		position.x = maxRight
