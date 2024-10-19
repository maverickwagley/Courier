#scr_particle_projectile
#
extends Node2D
#
@onready var particle: CPUParticles2D = $CPUParticles2D
@onready var proj_coll_snd: AudioStreamPlayer = $ProjCollisionSFX
@onready var damage_snd: AudioStreamPlayer = $DamageSFX
#
var fps: float = autoload_game.fps_target
var sd_timer: float = 30
var damaged: bool = false
#
#Built-In Functions
#
func _ready():
	particle.emitting = true
	if autoload_game.audio_mute == false:
		proj_coll_snd.play()
#
func _process(delta):
	if sd_timer > 0:
		sd_timer = sd_timer - (delta * fps)
	if sd_timer <= 0:
		queue_free()
