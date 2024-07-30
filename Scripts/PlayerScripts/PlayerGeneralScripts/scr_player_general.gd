extends Node

@onready var player: CharacterBody2D
#
func cursor_direction(_cdir):
	_cdir = wrapi(_cdir,0,360)
	if _cdir < 0:
		_cdir = 360 - _cdir
	if _cdir < 45:
			return "right"
	if _cdir >= 45:
		if _cdir < 135:
			return "down"
	if _cdir >= 135:
		if _cdir < 225:
			return "left"
	if _cdir >= 225:
		if _cdir < 315:
			return "up"
	if _cdir >= 315:
			return "right"
#
func form_swap(_form_menu):
	if _form_menu == true:
		return false
	else:
		return true
#
func part_spawn(_particle,_global_position,_global_rotation):
	var current_part = _particle.instantiate()
	for current_world in get_tree().get_nodes_in_group("World"):
		if current_world.name == "World":
			current_world.add_child(current_part) 
	current_part.global_position = _global_position
	current_part.global_rotation = _global_rotation - 3.14
#
func move_audio():
	pass
