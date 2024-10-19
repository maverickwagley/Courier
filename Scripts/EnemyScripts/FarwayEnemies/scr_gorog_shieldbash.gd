#scr_gorog_shieldbash
#
extends AttackArea
#
#
#Built-In Functions
#
func _ready():
	shape = $Attack2Damagebox
	attack_audio = $Attack2SFX
	attack_aud_timer = $Attack2AudioTimer
	#
	is_attack = false
	inflict_kb = false
	kb_power = 0.0
	damage = 40.0
	#var parent = get_parent()
	is_attack = false
	shape.disabled = true
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
