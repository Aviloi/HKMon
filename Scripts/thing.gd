extends Node2D

# stores the cell types and makes it so you can change things' type from inside godot
enum CELL_TYPES{ EMPTY = -1, ACTOR, OBSTACLE, OBJECT, TRANSITION }
export(CELL_TYPES) var type = CELL_TYPES.ACTOR

# originaly used this to save the target positions for transitions but actualy can be used
# as an id system and that's pog
# like for actors it can be: x = what character and y = what line of dialouge
export var id = Vector2(0,0)
