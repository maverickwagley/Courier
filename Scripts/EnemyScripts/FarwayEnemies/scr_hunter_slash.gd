#scr_hunter_slash
#
extends AttackArea
#
#Built-In Functions
#
func _ready():
	shape = $Attack1Damagebox
	attack_audio = $Attack1SFX
	attack_aud_timer = $Attack1AudioTimer
	var parent = get_parent()
	#
	is_attack = false
	inflict_kb = false
	kb_power = 0.0
	damage = 10.0
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
