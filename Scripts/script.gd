extends Node2D

#onready var ui = $Player/UI
var type = -1

func dial(id):
	if id.x == 0:
		if id.y == 0:
			self.get_parent().find_node("Label").text = "Hornet: here's just some placeholder text to see if it will work"
			self.get_parent().find_node("Panel").visible = !self.get_parent().find_node("Panel").visible

func obj(id,a):
	if id.x == 0:
		if id.y == 0:
			self.get_parent().find_node("Label").text = "this door is locked until the buggy mess that is transitions is fixed"
			self.get_parent().find_node("Panel").visible = !self.get_parent().find_node("Panel").visible
		elif id.y == 1:
			get_parent().fuck_this_door(a)
