extends Node2D

class_name Melee

@onready var melee_audio: AudioStreamPlayer = $MeleeSFX

var weapon: Area2D
var parent_velocity: Vector2
var audio_played: bool = false

func _ready():
	if get_children().is_empty(): return
	weapon = get_children()[0]
	weapon.disable()

func enable():
	if !weapon: return
	if audio_played == false:
		audio_played = true
		if autoload_game.audio_mute == false:
			melee_audio.play()
	visible = true
	weapon.parent_velocity = parent_velocity
	weapon.enable()

func disable():
	if !weapon: return
	audio_played = false
	visible = false
	weapon.disable()


