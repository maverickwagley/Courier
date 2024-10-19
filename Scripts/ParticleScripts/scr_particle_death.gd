#scr_particle_death
#
extends Node2D
#
@onready var particle: CPUParticles2D = $CPUParticles2D
#
var fps: float = autoload_game.fps_target
var sd_timer: float = 60
#
#Built-In Functions
#
func _ready():
	particle.emitting = true
#
func _process(delta):
	if particle.gravity.y > 0:
		particle.gravity.y = particle.gravity.y - (delta * fps)
	if sd_timer > 0:
		sd_timer = sd_timer - (delta * fps)
	if sd_timer <= 0:
		queue_free()
