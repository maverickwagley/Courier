extends Node2D

class_name Melee

var weapon: Area2D
var parent_velocity: Vector2

func _ready():
	if get_children().is_empty(): return
	weapon = get_children()[0]
	weapon.disable()

func enable():
	if !weapon: return
	visible = true
	weapon.parent_velocity = parent_velocity
	weapon.enable()

func disable():
	if !weapon: return
	visible = false
	weapon.disable()


