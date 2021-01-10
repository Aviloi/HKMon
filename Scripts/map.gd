extends TileMap

enum { EMPTY = -1, ACTOR, OBSTACLE}

func _ready():
	# calls every of it's children and sets their colisions on the tilemap
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

func get_cell_thing(coordinates):
	# calls every of it's children and returns the node with the same coordinates as requested
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(thing, direction):
	# saves the starting cell and the target cells as variables
	var cell_start = world_to_map(thing.position)
	var cell_target = cell_start + direction
	
	# checks to see what the target cell's type is and if it's empty, move there
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_thing_position(thing, cell_start, cell_target)

# keeping this for future use
#		ACTOR:
#			var thing_name = get_cell_thing(cell_target).name
#			print("Cell %s contains %s" % [cell_target, thing_name])

func update_thing_position(thing, cell_start, cell_target):
	# moves the player colision to the target cell and removes it from the starting cell
	set_cellv(cell_target, thing.type)
	set_cellv(cell_start, EMPTY)
	
	# returns the target position
	return map_to_world(cell_target) + cell_size / 2
