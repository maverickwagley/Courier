#scr_projectile_arrow_collision
#
extends AttackArea
#
#Built-In Functions
#
func _ready():
	#var player: CharacterBody2D
	inflict_kb = false
	type = 0
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
