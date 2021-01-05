extends Sprite

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		position.x -=16
		
	if Input.is_action_just_pressed("ui_right"):
		position.x +=16
		
	if Input.is_action_just_pressed("ui_up"):
		position.y -=16
		
	if Input.is_action_just_pressed("ui_down"):
		position.y +=16

