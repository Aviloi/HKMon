extends TileMap

enum { ACTIVE , INACTIVE, INTERACTING }
enum { EMPTY = -1, ACTOR, OBSTACLE, OBJECT, TRANSITION}

signal dial(actor)
signal obj(object)
signal fade_black(out)

func _ready():
	# calls every of it's children and sets their colisions on the tilemap
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

func get_cell_thing(coordinates, type):
	# calls every of it's children and returns the node with the same coordinates as requested
	#
	# the if not null is there because i want to use this function without type
	# but have no idea how to do it in another way
	if type != null:
		for node in get_children():
			if world_to_map(node.position) == coordinates and node.type == type:
				return(node)
	else:
		for node in get_children():
			if world_to_map(node.position) == coordinates:
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
		# checks to see what the target cell's type is and if it's empty, move there; if it's a transition, does the transition
		match cell_target_type:
			EMPTY:
				return update_thing_position(thing, cell_start, cell_target)
			TRANSITION:
				# sets player's state to inactive
				thing.state = INACTIVE
				
				# moves the player sprite to the tile infront of him and fades the screen to black
				thing.move_to(map_to_world(cell_target) + cell_size / 2)
				emit_signal("fade_black",true)
				
				
				# this fucking line of code gives an error in a completly diferent
				# part of the code, i have no idea how to fix it but it doesn't 
				# seem to affect the game that much so might aswell just...
				# leave it alone until it actually starts breaking things
				#
				# waits for the fade out to be finished before continuing the code
				yield($"/root/Game/UI/AnimationPlayer","animation_finished")
				
				# instantly moves the player to the transition's location
				thing.position = map_to_world(get_cell_thing(cell_target, TRANSITION).id) + cell_size / 2
				
				# updates the player's position to the target position and also fades from black
				emit_signal("fade_black",false)
				thing.move_to(update_thing_position(thing,cell_start,world_to_map(thing.position) +direction))
				
				# sets player's state to active
				thing.state = ACTIVE
	
	# if it's interacting, use this code
	else:
		# checks to see what the target cell's type is and if it's an actor, print it's position and name
		match cell_target_type:
			ACTOR:
				# emits the dial signal along with the target actor
				emit_signal("dial",get_cell_thing(cell_target, ACTOR))
			OBJECT:
				# emits the obj signal along with the target object
				emit_signal("obj",get_cell_thing(cell_target, OBJECT))

func update_tile(cell_target):
	# translates from global to local coordinates
	cell_target = world_to_map(cell_target)
	
	# updates the targeted cell
	set_cellv(cell_target, get_cell_thing(cell_target,null).type)

func update_thing_position(thing, cell_start, cell_target):
	# moves the player colision to the target cell and removes it from the starting cell
	set_cellv(cell_target, thing.type)
	set_cellv(cell_start, EMPTY)
	
	# returns the target position
	return map_to_world(cell_target) + cell_size / 2
