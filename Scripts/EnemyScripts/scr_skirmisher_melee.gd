extends Area2D


@onready var meleebox = $Damagebox
@onready var melee_audio = $MeleeSFX
@onready var melee_aud_timer = $MeleeAudioTimer

var is_melee: bool = false
var inflict_kb: bool = false
var kb_power: int = 0
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_melee == true:
		meleebox.disabled = false
	else:
		meleebox.disabled = true
