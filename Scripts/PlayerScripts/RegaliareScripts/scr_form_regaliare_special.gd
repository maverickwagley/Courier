#Regaliare Special Skill
#
extends Node2D
#
signal check_cost
signal special_end
signal form_status_set
signal player_status_set
signal player_gui_update
signal player_charge_use
signal player_cursor_los
#
@export var projectile_scene: PackedScene
#
#@onready var player: CharacterBody2D
@onready var special_snd: AudioStreamPlayer = $SpecialSFX
#
var parent_velocity: Vector2
var special_rate: int = 90
var special_cost: int = 100
var is_special: bool = false
var cost_check: bool = false
var cursor_los_check: bool = false
#
#Built-In Methods
#
func _physics_process(_delta) -> void:
	if is_special == true:
		emit_signal("check_cost","yellow_special",100)
		emit_signal("special_end")
		is_special = false
	if cost_check == true:
		cost_check = false
		projectile_create()
	
func projectile_create() -> void:
	#Move to form controller()
	if autoload_game.audio_mute == false:
		special_snd.play()
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.parent = self
	add_child(projectile)
	emit_signal("player_gui_update")
	emit_signal("player_status_set","is_attack",false)
	emit_signal("player_status_set","is_invincible",true)
	emit_signal("player_status_set","t_invincible",60)
	emit_signal("player_charge_use","yellow_special",special_cost)
	emit_signal("form_status_set","is_invincible",true)
