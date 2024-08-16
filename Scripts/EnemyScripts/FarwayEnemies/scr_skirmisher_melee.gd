#Skirmisher Melee
#
extends Area2D
#
@onready var meleebox = $Damagebox
@onready var melee_audio = $MeleeSFX
@onready var melee_aud_timer = $MeleeAudioTimer
#
var is_melee: bool = false
var inflict_kb: bool = false
var kb_power: int = 0
var damage: int = 10
#
#Built-In Methods
#
func _ready():
	var parent = get_parent()
	is_melee = false
#
func _process(delta):
	if is_melee == true:
		meleebox.disabled = false
	else:
		meleebox.disabled = true
