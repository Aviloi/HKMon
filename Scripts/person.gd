extends "thing.gd"

onready var Grid = get_parent()
export var movespeed = 0.3

func _ready():
	update_look_direction(Vector2(0, 1))

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	
	input_direction = remove_diagonal(input_direction)
	update_look_direction(input_direction)

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)

func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func remove_diagonal(direction):
	if(direction == Vector2(1,1) or direction == Vector2(1,-1)):
		return Vector2(1,0)
	elif(direction == Vector2(-1,-1) or direction == Vector2(-1,1)):
		return Vector2(-1,0)
	return direction

func move_to(target_position):
	set_process(false)
	
	$Pivot/Sprite.play()
	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Pivot, "position", - move_direction * 16, Vector2(), movespeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	position = target_position
	
	# Stop the function execution until the animation finished
	yield($Tween, "tween_completed")
	$Pivot/Sprite.stop()
	set_process(true)
	
func update_look_direction(direction):
	# -x left -y up
	if (direction.x<0):
		$Pivot/Sprite.animation = "WalkL"
	elif (direction.x>0):
		$Pivot/Sprite.animation = "WalkR"
	elif (direction.y<0):
		$Pivot/Sprite.animation = "WalkU"
	elif (direction.y>0):
		$Pivot/Sprite.animation = "WalkD"
