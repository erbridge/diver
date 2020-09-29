extends Node2D

onready var _spot_template
var _spots

func _ready():
	_spot_template = get_node("Spot")
	
	_spots = []
	for x in range(21):
		_spots.append([])
		for y in range(11):
			_spots[x].append(null)
	
	for j in range(0, 5):
		for i in range(-10, 11):
			var new_spot = _spot_template.duplicate()
			new_spot.position.x = i * 200
			new_spot.position.y = 200 * j
			new_spot.visible = true
			self.add_child(new_spot)
			_spots[i+10][j*2] = new_spot
			
		for i in range(-10, 10):
			var new_spot = _spot_template.duplicate()
			new_spot.position.x = i * 200 + 100
			new_spot.position.y = 200 * j + 100
			new_spot.visible = true
			self.add_child(new_spot)
			_spots[i+10][j*2+1] = new_spot

func get_closest_spot(var position) -> Node2D:
	var closestSpots = []
	for x in range(20):
		for y in range (10):
			## if there's no spot, stop checking
			if _spots[x][y] == null:
				continue
				
			## if the spot is taken, stop checking
			var spot = _spots[x][y]
			if spot.get_child_count() > 0:
				continue
			
			var distance = position.distance_to(spot.global_position)
			for i in range(closestSpots.count()):
				var stored_distance = position.distance_to(closestSpots[i].global_position)
				if distance < stored_distance:
					closestSpots.insert(i, spot)
					break
				closestSpots.append(spot)
	
	if (closestSpots.count() > 0):
		return closestSpots[0] as Node2D
	else:
		return null