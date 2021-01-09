extends TileMap

enum { EMPTY = -1, ACTOR, OBSTACLE}

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

func get_cell_thing(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(thing, direction):
	var cell_start = world_to_map(thing.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_thing_position(thing, cell_start, cell_target)
#		ACTOR:
#			var thing_name = get_cell_thing(cell_target).name
#			print("Cell %s contains %s" % [cell_target, thing_name])

func update_thing_position(thing, cell_start, cell_target):
	set_cellv(cell_target, thing.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target) + cell_size / 2
