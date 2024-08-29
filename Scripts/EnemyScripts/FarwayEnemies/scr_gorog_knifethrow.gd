#Hunter Attack 2 - Bowshot
#
extends Area2D
#
@onready var damagebox = $Attack2Damagebox
@onready var attack_timer = $Attack2Timer
@onready var attack_audio = $Attack2SFX
@onready var attack_aud_timer = $Attack2AudioTimer
#
var is_attack: bool = false
var inflict_kb: bool = false
var kb_power: int = 0
var damage: int = 10
#
#Built-In Methods
#
func _ready():
	var parent = get_parent()
	is_attack = false
	damagebox.disabled = true

