extends Node2D

@onready var particle: CPUParticles2D = $CPUParticles2D
@onready var proj_coll_snd: AudioStreamPlayer = $ProjCollisionSFX
@onready var damage_snd: AudioStreamPlayer = $DamageSFX
var sd_timer: int = 30
var damaged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	particle.emitting = true
	if ScrGameManager.audio_mute == false:
		proj_coll_snd.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sd_timer > 0:
		sd_timer = sd_timer - 1
	if sd_timer <= 0:
		queue_free()
