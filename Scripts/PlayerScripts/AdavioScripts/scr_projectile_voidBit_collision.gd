#scr_projectile_voidBit_collision
#
extends AttackArea
#
#Built-In Functions
#
func _ready():
	inflict_kb = false
	is_magic = true
	is_kinetic = false
	type = 1
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
