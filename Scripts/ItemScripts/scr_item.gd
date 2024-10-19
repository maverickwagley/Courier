#scr_item (Generic)
#
extends CharacterBody2D
#
@onready var player_collision: Area2D = $PlayerCollision
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var animations: AnimationPlayer = $ItemAnimation
#
var speed = 25
var sd_timer: int = 3600
var direction: Vector2 = Vector2.RIGHT
var classed: bool = false
var class_update: bool = false
var magnet: bool = false
var player: CharacterBody2D
var magnet_target: CharacterBody2D
var t_magnet = 25
var item_class: int = 0
var item_id: int = 0
var amount: int = randi_range(5,25)
var parent_velocity: Vector2
#
#Built-In Functions
#
func _ready() -> void:
	global_rotation = global_rotation + randf_range(-3.14,3.14)
	direction = Vector2.RIGHT.rotated(global_rotation)
	update()
#
func _physics_process(delta) -> void:
	if sd_timer > 0:
		sd_timer = sd_timer - 1
	#
	if classed == true:
		if class_update == false:
			update()
			class_update = true
	if t_magnet > 0:
		t_magnet = t_magnet - 1
		if speed > 0:
			speed = speed - 1
			velocity = direction * speed * delta
	else:
		if magnet == true:
			direction = global_position.direction_to(magnet_target.global_position)
			speed = speed + 1
			velocity = direction * speed * delta
	var collision = move_and_collide(velocity)
	#
	if sd_timer <= 0:
		queue_free()
#
#Custom Scripts
#
func update() -> void:
	if item_class == 0:
		match item_id:
			0:
				animations.play("anim_item_ess_yellow")
			1:
				animations.play("anim_item_ess_violet")
			2:
				animations.play("anim_item_ess_green")
			3:
				animations.play("anim_item_ess_blue")
			4:
				animations.play("anim_item_ess_orange")
			5:
				animations.play("anim_item_ess_red")
			6:
				animations.play("anim_item_ess_life")
#
func update_player(_player) -> void:
	if item_class == 0:
		match item_id:
			0:
				_player.yellow_primary = _player.yellow_primary + amount
				_player.yellow_special = _player.yellow_special + amount
				_player.player_hud.gui_update_all()
			1:
				_player.violet_primary = _player.violet_primary + amount
				_player.violet_special = _player.violet_special + amount
				_player.player_hud.gui_update_all()
			2:
				_player.green_primary = _player.green_primary + amount
				_player.green_special = _player.green_special + amount
				_player.player_hud.gui_update_all()
			3:
				_player.blue_primary = _player.blue_primary + amount
				_player.blue_special = _player.blue_special + amount
				_player.player_hud.gui_update_all()
			4:
				_player.orange_primary = _player.orange_primary + amount
				_player.orange_special = _player.orange_special + amount
				_player.player_hud.gui_update_all()
			5:
				_player.red_primary = _player.red_primary + amount
				_player.red_special = _player.red_special + amount
				_player.player_hud.gui_update_all()
			6:
				_player.hp = _player.hp + amount
				_player.player_hud.gui_update_all()
#
#Signal Functions
#
func _on_player_collision_area_entered(area) -> void:
	player = area.get_parent()
	update_player(player)
	#print_debug("Player Collision")
	queue_free()
	pass # Replace with function body.
#
func _on_magnetism_area_entered(area) -> void:
	#print_debug(area.get_parent())
	magnet = true
	magnet_target = area.get_parent()
	speed = 25
	
