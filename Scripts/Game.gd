extends Node2D

onready var ui = $UI
onready var animation = $UI/AnimationPlayer
onready var text_box = $UI/Textbox
onready var text = $UI/Textbox/Label
onready var grid = $Collision
onready var player = $Collision/Player

# loads the tilesets so it can dynamically change to debug and normal mode
onready var tilesetNormal = load("res://Tilesets/export.tres")
onready var tilesetDebug = load("res://Tilesets/debug.tres")

# enumenator containing the states the player can be in
enum { ACTIVE , INACTIVE, INTERACTING }

# to do: replace the ifs with match cases
# to do: setup a dictionary somewhere explaining what id does what
# to do: use a json file to save dialouge instead of just hardcoding the text

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("show_hitboxes"):
		if grid.tile_set == tilesetNormal:
			grid.tile_set = tilesetDebug
		else:
			grid.tile_set = tilesetNormal

func dial(actor):
	# variables storing the character name and a text array
	var person
	var line
	
	# makes the text box visible and sets the player to the interacting state
	text_box.visible = true
	player.state = INTERACTING
	
	# x is the character that speaks, y are the lines of that character
	if actor.id.x == 0:
		person = "Hornet: %s"
		if actor.id.y == 0:
			line = ["Here's just some placeholder text to see if it will work.",
				"Oh wait, it actually works this time?",
				"Poggers!"]
	
	talk(person,line)

func talk(person,line):
	# for every line in the text array
	for a in line:
		# change the text to the character name + that line
		text.text = person % a
		
		# plays the textbox animations
		ui.arrow()
		# waits for player input
		yield(player,"input")
		
		# plays the arrow_out animation and waits until it's done before continuing
		animation.play("arrow_out")
		yield(animation,"animation_finished")
	# after every line has been said, make the text box invisible and set the player state to active
	text_box.visible = false
	player.state = ACTIVE

func obj(object):
	if object.id.x == 0:
		object.queue_free()
		grid.update_tile(object.position)
