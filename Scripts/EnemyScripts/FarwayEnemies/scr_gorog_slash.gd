#scr_gorog_slash
#
extends AttackArea
#
#@onready var damagebox = $Attack1Damagebox
#@onready var attack_audio = $Attack1SFX
#@onready var attack_aud_timer = $Attack1AudioTimer
##
#var is_attack: bool = false
#var inflict_kb: bool = false
#var targets_hit: Array
#var kb_power: int = 0
#var damage: int = 30
#
#Built-In Functions
#
func _ready():
	shape = $Attack1Damagebox
	attack_audio = $Attack1SFX
	attack_aud_timer = $Attack1AudioTimer
	var parent = get_parent()
	
	is_attack = false
	inflict_kb = false
	kb_power = 0.0
	damage = 30.0
	shape.disabled = true
#
func _process(delta):
	if is_attack == true:
		shape.disabled = false
	else:
		shape.disabled = true
#
#Custom Functions
#
func collide() -> void:
	attack_collision_standard()
