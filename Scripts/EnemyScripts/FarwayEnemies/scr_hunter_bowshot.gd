#Hunter Attack 2 - Bowshot
#
extends Area2D
#
@onready var damagebox = $Attack2Damagebox
#@onready var attack_audio = $Attack1SFX
#@onready var attack_aud_timer = $Attack1AudioTimer
#
var is_attack: bool = false
var inflict_kb: bool = false
var kb_power: int = 0
var damage: int = 15
#
#Built-In Methods
#
func _ready():
	var parent = get_parent()
	is_attack = false
	damagebox.disabled = true

