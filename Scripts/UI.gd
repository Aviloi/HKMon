extends CanvasLayer

onready var player = $"/root/Game/Collision/Player"
onready var animation = $AnimationPlayer
var color = "#dc64d7"

func _ready():
	# makes sure the black rectangle used to fade in/outs is vissible
	$ColorRect.visible = true
	# fades in screen 
	fade_black(false)

func fade_black(out):
	
	# Checks to see if it should fade in or out and changes the transparancy acordingly
	if(out):
		animation.play("fade_out")
	else:
		animation.play("fade_in")

func arrow():
	# i am too tired to explain what this does and i'll be revamping it anyways so why bother
	animation.play("text_in")
	yield(animation,"animation_finished")
	animation.play("arrow_in")
	yield(animation,"animation_finished")
	animation.play("arrow_idle")

# warning-ignore:unused_argument
func _process(delta):
	
	if Input.is_action_pressed("ui_up"):
		$Overlay/W.color = color
	else:
		$Overlay/W.color = "#ffffff"
	
	if Input.is_action_pressed("ui_left"):
		$Overlay/A.color = color
	else:
		$Overlay/A.color = "#ffffff"
	
	if Input.is_action_pressed("ui_down"):
		$Overlay/S.color = color
	else:
		$Overlay/S.color = "#ffffff"
	
	if Input.is_action_pressed("ui_right"):
		$Overlay/D.color = color
	else:
		$Overlay/D.color = "#ffffff"
		
	if Input.is_action_pressed("ui_accept"):
		$Overlay/Z.color = color
	else:
		$Overlay/Z.color = "#ffffff"
		
	if Input.is_action_pressed("show_hitboxes"):
		$Overlay/tilde.color = color
	else:
		$Overlay/tilde.color = "#ffffff"
