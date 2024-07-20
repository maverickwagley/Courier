extends Node2D

@onready var particle: CPUParticles2D = $CPUParticles2D

var sd_timer: int = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	particle.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if particle.gravity.y > 0:
		particle.gravity.y = particle.gravity.y - 1
	if sd_timer > 0:
		sd_timer = sd_timer - 1
	if sd_timer <= 0:
		queue_free()
