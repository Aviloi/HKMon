extends "thing.gd"

onready var Grid = get_parent()
export var movespeed = 0.3
signal bitch

# saves the direction the player's facing so it can be used for the interaction code
var current_direction = Vector2()

func _ready():
	# when the player is called, make it look down
	update_look_direction(Vector2(0, 1))
	fade_black(false)

# warning-ignore:unused_argument
func _process(delta):
	# checks if the player is pressing the interaction button
	interaction()
	
	#checks if the player is pressing any of the movement buttons
	var input_direction = get_input_direction()
	
	# if the input is empty, don't run the rest of the code
	if not input_direction:
		return
	
	# self explanatory 
	input_direction = remove_diagonal(input_direction)
	update_look_direction(input_direction)
	
	# calls the tilemap to see if it can to the spot
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
	# Stop it listening for new inputs and play the walking animation
	set_process(false)
	$Sprite.play()
	
	# Smoothly change the current position to the target position
	$Tween.interpolate_property(self, "position", position, target_position, movespeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	# Stop the function execution until the tween is finished
	yield($Tween, "tween_completed")
	
	# Stop the walking animation and continue listening for inputs
	$Sprite.stop()
	set_process(true)

func fade_black(out):
	set_process(false)
	if(out):
		$Tween.interpolate_property($UI/ColorRect,"color:a",0,1,movespeed*2)
	else:
		$Tween.interpolate_property($UI/ColorRect,"color:a",1,0,movespeed*2)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("bitch")
	set_process(true)

func update_look_direction(direction):
	# -x left -y up
	# checks to see what the direction is and changes to the needed animation
	current_direction = direction
	if (direction.x<0):
		$Sprite.animation = "WalkL"
	elif (direction.x>0):
		$Sprite.animation = "WalkR"
	elif (direction.y<0):
		$Sprite.animation = "WalkU"
	elif (direction.y>0):
		$Sprite.animation = "WalkD"
