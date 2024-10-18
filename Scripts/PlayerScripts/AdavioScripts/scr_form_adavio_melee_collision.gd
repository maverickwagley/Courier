#scr_form_adavio_melee_collision
#
extends AttackArea
#
#Built-In Methods
#
func _ready() -> void:
	shape = $MeleeShape
	shape.disabled = true
	damage = 60
	inflict_kb = true
	is_magic = false
	is_kinetic = true
	kb_power = 175
	type = 1
#
#Custom Methods
#
func collide() -> void:
	attack_collision_standard()
