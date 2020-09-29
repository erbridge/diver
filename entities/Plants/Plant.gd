extends Sprite

var _is_growing = false
var _is_shrinking = false
var _accumulated_scale = 0
export var _growth_speed = 0.2
export var _shrink_speed = 1.0

var dragging = false
var click_radius = 32 # Size of the sprite.
onready var _main = get_tree().get_root().get_node("Main")

func _ready() -> void:
	scale = Vector2.ZERO
	_is_growing = true
	
func set_scale(var target) -> void:
	_is_growing = false
	scale = Vector2.ONE * target
	
	_accumulated_scale = target
	_is_shrinking = true
	
func _process(delta) -> void:
	if _is_growing:
		_accumulated_scale += delta * _growth_speed
		if (_accumulated_scale >= 1.0):
			_accumulated_scale = 1.0
			_is_growing = false
			
		scale = Vector2.ONE * _accumulated_scale
	
	if _is_shrinking:
		_accumulated_scale -= delta * _shrink_speed
		if (_accumulated_scale <= 1.0):
			_accumulated_scale = 1.0
			_is_shrinking = false
			
		scale = Vector2.ONE * _accumulated_scale

func save() -> Dictionary:
	var dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return dict
	
func set_dragging() -> void:
	dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if (get_global_mouse_position() - position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
			
			var node = _main._garden.get_closest_spot(position)
			if node != null:
				position = node.get_global_position()
				node.add_child(self)
			
			_main.save_game()

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		position = get_global_mouse_position()
