#scr_skirmisher_slash
#
extends AttackArea
#
#@onready var damagebox = $Attack1Damagebox
#@onready var attack_audio = $Attack1SFX
#@onready var attack_aud_timer = $Attack1AudioTdimer
##
#var is_attack: bool = false
#var inflict_kb: bool = false
#var targets_hit: Array
#var kb_power: int = 0
#var damage: int = 10
#
#Built-In Functions
#
func _ready():
	shape = $Attack1Damagebox
	attack_audio = $Attack1SFX #Move up to Enemy?
	attack_aud_timer = $Attack1AudioTimer #Move up to Enemy?
	var parent = get_parent() #Move up to Enemy?
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
