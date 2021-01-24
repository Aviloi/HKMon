extends "thing.gd"

# enumenator containing the states the player can be in
enum { ACTIVE , INACTIVE, INTERACTING }

# the grid used for collisions and shit
onready var Grid = get_parent()
# the animation tree and state of the animation
onready var tree = $AnimationTree
onready var animation_state = tree.get("parameters/playback")

# player's movespeed
export var movespeed = 0.3

# the state of the player, starts of as inactive
var state = INACTIVE
# the player direction used for interaction
var current_direction = Vector2()

signal input

func _ready():
	# makes sure the animation tree is active
	tree.active = true
	
	# waits for the fade in to be done
	yield($"/root/Game/UI/AnimationPlayer","animation_finished")
	
	# set's the player's state to active
	state = ACTIVE

# warning-ignore:unused_argument
func _process(delta):
	# checks what state the player is in
	match state:
		ACTIVE:
			active_state()
		INTERACTING:
			animation_state.travel("Idle")
			interacting_state()
		INACTIVE:
			animation_state.travel("Idle")

func active_state():
	# checks if the player is pressing the interaction button
	interaction()
	
	# checks if the player is pressing any of the movement buttons
	var input_direction = get_input_direction()
	
	# if the input is empty, set the animation state to idle and don't run the rest of the code
	if not input_direction:
		animation_state.travel("Idle")
		return
	
	# removes diagonal movement
	input_direction = remove_diagonal(input_direction)
	
	# logs the current direction
	current_direction = input_direction
	
	# updates the direction ofthe animations
	tree.set("parameters/Idle/blend_position",input_direction)
	tree.set("parameters/Walk/blend_position",input_direction)
	
	# sets the animation state to walk
	animation_state.travel("Walk")
	
	# calls the tilemap to see if it can move to the spot
	var target_position = Grid.request_tile(self, input_direction,true)
	
	# if it can, move it there, if not do nothing
	if target_position:
		move_to(target_position)

func interaction():
	if Input.is_action_just_pressed("ui_accept"):
		Grid.request_tile(self, current_direction, false)

func get_input_direction():
	# returns a vector 2 depending on what keys are pressed
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func remove_diagonal(direction):
	# if it's a right-down or a right-up diagonal, change it to right movement
	if(direction == Vector2(1,1) or direction == Vector2(1,-1)):
		return Vector2(1,0)
		
	# else if it's a left-down or a left-up diagonal, change it to left movement
	elif(direction == Vector2(-1,1) or direction == Vector2(-1,-1)):
		return Vector2(-1,0)
		
	# if it isn't diagonal, return the direction without change
	return direction

func move_to(target_position):
	# Stop it listening for new inputs
	set_process(false)
	
	# Smoothly change the current position to the target position
	$Tween.interpolate_property(self, "position", position, target_position, movespeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	# Stop the function execution until the tween is finished
	yield($Tween, "tween_completed")
	
	# continue listening for inputs
	set_process(true)

func interacting_state():
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("input")
