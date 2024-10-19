#scr_particle_generic
#
extends Node2D
#
@onready var particle: CPUParticles2D = $CPUParticles2D
var fps: float = autoload_game.fps_target
var sd_timer: float = 15
#
#Built-In Functions
#
func _ready():
	particle.emitting = true
#
func _process(delta):
	if sd_timer > 0:
		sd_timer = sd_timer - (delta * fps)
	if sd_timer <= 0:
		queue_free()
