extends TileMap

enum { EMPTY = -1, ACTOR, OBSTACLE, OBJECT, TRANSITION}

func _ready():
	# calls every of it's children and sets their colisions on the tilemap
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

func get_cell_thing(coordinates, type):
	# calls every of it's children and returns the node with the same coordinates as requested
	for node in get_children():
		if world_to_map(node.position) == coordinates and node.type == type:
			return(node)

func request_tile(thing, direction,type):
	# type is used to see if the code is called for moving or interacting (true = movement, false = interacting)
	
	# saves the starting cell and the target cells as variables
	var cell_start = world_to_map(thing.position)
	var cell_target = cell_start + direction
	
	# stores the target cell's type
	var cell_target_type = get_cellv(cell_target)
	
	# if it's moving, use this code
	if (type):
		# checks to see what the target cell's type is and if it's empty, move there
		match cell_target_type:
			EMPTY:
				return update_thing_position(thing, cell_start, cell_target)
			TRANSITION:
				pass
				thing.move_to(map_to_world(cell_target) + cell_size / 2)
				
				thing.fade_black(true)
				yield(thing,"bitch")
				thing.position = update_thing_position(thing, cell_start, get_cell_thing(cell_target, TRANSITION).pos)
				thing.fade_black(false)
				
	
	# if it's interacting, use this code
	else:
		# checks to see what the target cell's type is and if it's an actor, print it's position and name
		match cell_target_type:
			ACTOR:
				$script.dial(get_cell_thing(cell_target, ACTOR).pos)
			OBJECT:
				$script.obj(get_cell_thing(cell_target, OBJECT).pos, cell_target)

func fuck_this_door(cell_target):
	get_cell_thing(cell_target, OBJECT).queue_free()
	set_cellv(cell_target, TRANSITION)

func update_thing_position(thing, cell_start, cell_target):
	# moves the player colision to the target cell and removes it from the starting cell
	set_cellv(cell_target, thing.type)
	set_cellv(cell_start, EMPTY)
	
	# returns the target position
	return map_to_world(cell_target) + cell_size / 2
