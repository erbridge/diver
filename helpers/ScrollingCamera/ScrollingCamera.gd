extends Camera2D

export (NodePath) var target
export (float) var margin = 150

var scroll_factor = 100

var target_node

func ensure_target_visibility(delta):
  if not target_node:
    return

  var viewport_rect = get_viewport_rect()
  var inner_limits = viewport_rect.grow(-margin)

  var target_screen_transform = target_node.get_global_transform_with_canvas()
  var target_screen_position = target_screen_transform.get_origin()

  if inner_limits.has_point(target_screen_position):
    return

  if viewport_rect.grow_individual(-margin, 0, 0, 0).has_point(target_screen_position):
    position += scroll_factor * delta * Vector2.RIGHT

  if viewport_rect.grow_individual(0, -margin, 0, 0).has_point(target_screen_position):
    position += scroll_factor * delta * Vector2.DOWN

  if viewport_rect.grow_individual(0, 0, -margin, 0).has_point(target_screen_position):
    position += scroll_factor * delta * Vector2.LEFT

  if viewport_rect.grow_individual(0, 0, 0, -margin).has_point(target_screen_position):
    position += scroll_factor * delta * Vector2.UP

func _ready():
  if target:
    target_node = get_node(target)

func _process(delta):
  if current:
    ensure_target_visibility(delta)
