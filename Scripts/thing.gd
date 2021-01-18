extends Node2D

# stores the cell types and makes it so you can change things' type from inside godot
enum CELL_TYPES{ ACTOR, OBSTACLE, OBJECT, TRANSITION }
export(CELL_TYPES) var type = CELL_TYPES.ACTOR
export var pos = Vector2(0,0)
