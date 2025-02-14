#scr_form_adavio_melee
#
extends Node2D
#
@onready var melee_audio: AudioStreamPlayer = $MeleeSFX
@onready var player: CharacterBody2D
#
var weapon: Area2D
var parent_velocity: Vector2
var cursor_los_check: bool = false
var audio_played: bool = false
#
#Built-In Functions
#
func _ready() -> void:
	if get_children().is_empty(): return
	weapon = get_children()[0]
	weapon.disable()
#
#Custom Functions
#
func enable() -> void:
	if !weapon: return
	if audio_played == false:
		audio_played = true
		if autoload_game.audio_mute == false:
			melee_audio.play()
	visible = true
	weapon.parent_velocity = parent_velocity
	weapon.enable()
#
func disable() -> void:
	if !weapon: return
	audio_played = false
	visible = false
	weapon.disable()
