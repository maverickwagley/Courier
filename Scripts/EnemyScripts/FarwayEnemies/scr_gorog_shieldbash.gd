#Gorog Attack 2 - Shield and Shield Bash
#
extends Area2D
#
@onready var damagebox = $Attack2Damagebox
@onready var attack_audio = $Attack2SFX
@onready var attack_aud_timer = $Attack2AudioTimer
#
var is_attack: bool = false
var inflict_kb: bool = false
var targets_hit: Array
var kb_power: int = 0
var damage: int = 40
#
#Built-In Methods
#
func _ready():
	var parent = get_parent()
	is_attack = false
	damagebox.disabled = true

