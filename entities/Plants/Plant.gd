extends Sprite

var _is_growing = false
var _is_shrinking = false
var _accumulated_scale = 0
export var _growth_speed = 0.2
export var _shrink_speed = 1.0
var _node
var creation_time = 0

var _target_scale = 1.0
var dragging = false
var click_radius = 32 # Size of the sprite.
onready var _main = get_tree().get_root().get_node("Main")
var _has_inited = false

var _baby_flower = preload("res://entities/Plants/BabyPlant.png")
var _full_flower = preload("res://entities/Plants/FullGrownPlant.png")

func _ready() -> void:
	scale = Vector2.ZERO
	_is_growing = true
	if !is_in_group("plants"):
		add_to_group("plants")
	
func set_scale(var target) -> void:
	_is_growing = false
	scale = Vector2.ONE * target
	
	_accumulated_scale = target
	_is_shrinking = true
	
func _process(delta) -> void:
	if !_has_inited:
		_initialize()
		
	if _is_growing:
		_accumulated_scale += delta * _growth_speed
		if (_accumulated_scale >= _target_scale):
			_accumulated_scale = _target_scale
			_is_growing = false
			
		scale = Vector2.ONE * _accumulated_scale
	
	if _is_shrinking:
		_accumulated_scale -= delta * _shrink_speed
		if (_accumulated_scale <= _target_scale):
			_accumulated_scale = _target_scale
			_is_shrinking = false
			if _target_scale == 0.0:
				_do_swap()
			
		scale = Vector2.ONE * _accumulated_scale

func _initialize() -> void:
	_has_inited = true
	if (creation_time <= OS.get_unix_time() - 1):
		_do_swap()
	
func save() -> Dictionary:
	var dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"creation_time" : creation_time
	}
	return dict
	
func set_dragging() -> void:
	dragging = true

func _input(event):
	var touchPos = get_canvas_transform().affine_inverse().xform(event.position)
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if (touchPos - position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
			if _node != null:
				_node.remove_plant(self)
				
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
			
			var node = _main._garden.get_closest_spot(position)
			if node != null:
				position = node.get_global_position()
				node.add_plant(self)
				_is_shrinking = true
				_target_scale = 0.0
			
			_main.save_game()

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		position = touchPos

func set_spot(var node) -> void:
	_node = node
	
func _do_swap() -> void:
	if (creation_time <= OS.get_unix_time() - 600):
		texture = _full_flower
	else:
		texture = _baby_flower
	_is_growing = true
	_target_scale = 1.0

func start_new_plant() -> void:
	add_to_group("persist")
	add_to_group("plants")
	set_scale(4.0)
	set_dragging()
	creation_time = OS.get_unix_time()
