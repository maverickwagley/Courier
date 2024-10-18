#scr_form_regaliare_melee_collision
#
extends AttackArea
#
func _ready():
	shape = $Damagebox
	shape.disabled = true
	damage = 35
	inflict_kb = true
	is_magic = false
	is_kinetic = true
	kb_power = 100
	type = 0
#
#Custom Methods
#
func collide() -> void:
	attack_collision_standard()
