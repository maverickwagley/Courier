#scr_projectile_goldArcs_collision
#
extends AttackArea
#
var player: CharacterBody2D
var t1: int = 0
#
#Built-In Methods
#
func _ready():
	inflict_kb = false
	is_magic = true
	is_kinetic = false
	kb_power = 250
	type = 0
#
func _process(delta):
	if t1 >= 0:
		t1 = t1 - (delta * 60)
		
	if t1 <= 0:
		target_hit.clear()
		t1 = 15
#
func collide() -> void:
	attack_collision_standard()
