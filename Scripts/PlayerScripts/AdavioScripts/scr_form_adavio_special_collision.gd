#scr_form_adavio_special_collision
#
extends AttackArea
#
#Built-In Methods
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
#Custom Methods
#
func collide() -> void:
	#Generate 3 Overshield
	attack_collision_standard()
