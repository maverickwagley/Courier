extends CharacterBody2D

@onready var sprite: Sprite2D = $FragmentSprite
@onready var animation: AnimationPlayer = $AnimationPlayer

var speed: int = 250
var sd_timer: int = 30
var direction: Vector2
#
func _ready():
	print_debug("Frag Created")
#
func _phyics_process(delta):
	speed = lerp(250,0,.75)
	print_debug(speed)
	velocity = direction * speed * delta
	if speed < .1:
		sd_timer = sd_timer - 1
		if sd_timer <= 0:
			animation.play("anim_fade_out")
			await animation.animation_finished
			#queue_free()
