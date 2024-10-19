#scr_projectile_goldBolt_collision
#
extends AttackArea
#
#Built-In Functions
#
func _ready() -> void:
	inflict_kb = false
	is_magic = true
	is_kinetic = false
	type = 0
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
