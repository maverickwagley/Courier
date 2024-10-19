#scr_form_adavio_special_collision
#
extends AttackArea
#
signal special_collision
#
#Built-In Functions
#
func _ready()  -> void:
	shape = $SpecialShape
	shape.disabled = true
	damage = 65
	inflict_kb = true
	is_magic = true
	is_kinetic = false
	kb_power = 250
	type = 1
#
#Custom Functions
#
func collide() -> void:
	emit_signal("special_collision")
	attack_collision_standard()
