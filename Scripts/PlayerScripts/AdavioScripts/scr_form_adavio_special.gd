#Adavio Special Skill
#
extends Node2D
#
signal check_cost
signal form_status_set
signal player_status_set
signal player_gui_update
signal player_charge_use
signal player_camera_shake
signal player_cursor_los
#
@export var projectile_scene: PackedScene
#
@onready var special_collision: Area2D = $SpecialArea
@onready var special_snd: AudioStreamPlayer = $SpecialSFX
@onready var player: CharacterBody2D
#
var parent_velocity: Vector2
var cursor_los_check: bool = false
var is_special: bool = false
var special_use: bool = false
var cost_check: bool = false
var t1: int
var t2: int
#
#Built-In Methods
#
func _ready() -> void:
	special_collision.disable()
	pass # Replace with function body.
#
func _physics_process(_delta) -> void:
	if is_special == true:
		emit_signal("check_cost","violet_special",75)
		if cost_check == true: 
			special_use = true
			emit_signal("form_set_status","special_start",true)
			emit_signal("form_set_status","is_special",true)
		else:
			emit_signal("form_set_status","is_attack",false)
			emit_signal("form_set_status","is_special",false)
			emit_signal("form_set_status","special_start",false)
			emit_signal("form_set_status","special_use",false)
			emit_signal("player_status_set","is_attack",false)
			emit_signal("player_status_set","is_special",false)
			is_special = false
			special_use = false
			special_collision.disable()
		if special_use == true:
			t1 = t1 - 1
			print_debug("t1: " + str(t1))
			if t1 <= 0:
				special_collision.enable()
				t1 = 70
			t2 = t2 - 1
			print_debug("t2: " + str(t2))
			if t2 <= 0:
				emit_signal("player_camera_shake",3)#player.camera.apply_shake(3)
				for i in 5:
					var projectile = projectile_scene.instantiate()
					projectile.global_position = global_position + projectile.direction.normalized() * 5
					projectile.global_position = global_position
					projectile.global_rotation = (6.28/5) * i
					projectile.z_index = z_index
					get_tree().current_scene.add_child(projectile)
				t2 = 70
		else:
			if Input.is_action_just_pressed("special_skill"):
					is_special = false
					special_use = false
					emit_signal("form_status_set","is_attack",false)
					emit_signal("form_status_set","is_special",false)
					emit_signal("form_status_set","special_start",false)
					emit_signal("form_status_set","special_use",false)
					emit_signal("player_status_set","is_attack",false)
					emit_signal("player_status_set","is_special",false)
					#parent.is_special = false
					#parent.is_attack = false
					#parent.special_start = false
					#parent.special_use = false
					#player.is_special = false
					#player.is_attack = false
					special_collision.disable()
#
#Custom Methods
#
func special_check() -> bool:
	#Check Line of Sight w/ Raycast
	#special_collision.set_collision_mask_value(6,false)
	var _playPos: Vector2 = player.global_position
	var _cursPos: Vector2 = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(_playPos, _cursPos)
	query.set_collision_mask(0b00000000_00000000_00000001_00000000)
	query.exclude = [player]
	var result = space_state.intersect_ray(query)
	if result:
		return true
	else: 
		return false
