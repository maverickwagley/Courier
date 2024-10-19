#scr_hunter_bowshot
#
extends AttackArea
#
#Built-In Functions
#
func _ready():
	#var parent = get_parent()
	shape = $Attack2Damagebox
	attack_audio = $Attack2SFX
	attack_aud_timer = $Attack2AudioTimer
	#
	is_attack = false
	inflict_kb = false
	kb_power = 0.0
	damage = 10.0
	shape.disabled = true
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
