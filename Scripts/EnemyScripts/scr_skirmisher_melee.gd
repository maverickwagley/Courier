extends Area2D


@onready var meleebox = $Damagebox

var is_melee: bool = false
var inflict_kb: bool = false


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
