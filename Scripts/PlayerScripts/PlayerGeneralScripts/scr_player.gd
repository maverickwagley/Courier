#Player
#
extends CharacterBody2D
#GUI and Display
@onready var player_hud: CanvasLayer = $PlayerHUD
@onready var health_gui: TextureProgressBar = $PlayerHUD/HealthBar
@onready var stamina_gui: TextureProgressBar = $PlayerHUD/StaminaBar
@onready var primary_gui: TextureProgressBar = $PlayerHUD/PrimaryBar
@onready var special_gui: TextureProgressBar = $PlayerHUD/SpecialBar
@onready var dead_gui: Label = $PlayerHUD/DeadLabel
@onready var form_controller: CanvasLayer = $FormSwapMenu
@onready var pause_controller: CanvasLayer = $PauseMenu
@onready var cursor: Node2D = $Cursor/CursorManager
#Other
@onready var camera: Camera2D = $Camera2D
@onready var hurt_box: Area2D = $Hitbox
@onready var damage_dealt_audio: AudioStreamPlayer = $DamageSFX
@onready var hurt_audio: AudioStreamPlayer = $HurtSFX
#Room
var tilemap: TileMapLayer 
var room_space = get_parent()
#Form
var form: Node2D
var load_form: PackedScene
var form_id: int = 0
var form_type: int = 0
var entity_type:int = 0 
#Stats
#Stats that are upgradable should be moved to autoload
var hp: int = 200
var max_hp: int = 200
var stamina: int = 200
var max_stamina: int = 200
var shield: int = 0
var max_shied: int = 0
var speed: int = 65
var yellow_primary: int = 200
var violet_primary: int = 200
var green_primary: int = 200
var blue_primary: int = 200
var orange_primary: int = 200
var red_primary: int = 200
var current_primary: int = 200
var yellow_special: int = 200
var violet_special: int = 200
var green_special: int = 200
var blue_special: int = 200
var orange_special: int = 200
var red_special: int = 200
var current_special: int = 200
var yellow_max: int = 200
var violet_max: int = 200
var green_max: int = 200
var blue_max: int = 200
var orange_max: int = 200
var red_max: int = 200
var current_max: int = 200
#Status
var is_invincible: bool = false
var is_shielded: bool = false
var is_swap: bool = false
var is_hurt: bool = false
var is_dead: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
#Timers
var t_stamina: int = 0
var t_hurt: int = 0
var t_invincible: int = 0
var t_special: int = 0
var t_shield: int = 0
var t_dead: int = 0
var t_swap: int = 0
#Animation
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
#Other
var fps: int = autoload_game.fps_target
var roll_shake: bool = false
var form_menu: bool = false
var pause_menu: bool = false
#
#Built-In Methods
#
func _ready() -> void:
	autoload_player.player = self
	load_form = autoload_player.form_array[0]
	form = load_form.instantiate()
	add_child(form)
	player_signal_connections()
	form_controller.player_form = 0
	form_id = 0
#
func _physics_process(delta) -> void:
	player_update_status(delta)
	if is_dead == false:
		player_handle_input()
	else:
		#player_death_process()
		visible = false
		if t_dead <= 0:
			is_dead = false
			is_swap = true
			dead_gui.visible = false
			form.sprite._set("is_hurt",false)
			form.form_swap_in()
			form.sprite.apply_intensity_fade(1.0,0.0,0.5)
#
#Custom Methods
#
func player_signal_connections() -> void:
	form.connect("status_set",_on_status_set)
	form.connect("status_reset",_on_status_reset)
	form.connect("gui_update",_on_gui_update)
	form.connect("check_cost",_on_check_cost)
	form.connect("charge_use",_on_charge_use)
	form.connect("camera_shake",_on_camera_shake)
	form.connect("cursor_los_check",_on_cursor_los_check)
#
func player_update_status(delta) -> void:
	#CM: _physics_process
	visible = true
	if is_dead == true:
		if t_dead > 0:
			t_dead = t_dead - (delta * fps)
	if is_swap == true:
		if t_swap > 0:
			t_swap = t_swap - (delta * fps)
		if t_swap <= 0:
			player_form_swap()
	if stamina < max_stamina:
		if t_stamina > 0:
			t_stamina = t_stamina - (delta * fps)
		if t_stamina <= 0:
			t_stamina = 3
			stamina = stamina + (delta * fps)
			stamina_gui.update() 
	if is_hurt == true:
		if t_hurt > 0:
			t_hurt = t_hurt - (delta * fps)
		if t_hurt <= 0:
			is_hurt = false
			is_knockback = false
			form.is_hurt = false
			form.is_knockback = false
			form.sprite._set("is_hurt",false)
	if is_invincible == true:
		if t_invincible > 0:
			t_invincible = t_invincible - (delta * fps)
		if t_invincible <= 0:
			is_invincible = false
			form.is_invincible = false
			form.sprite._set("is_invincible",false)
	if is_shielded == true:
		pass
	if is_special == false:
		player_special_timer(delta)
#
func player_handle_input() -> void:
	#CM: _phsyics_process
	if move_and_slide():
		player_roll_collision()
	if is_knockback == false:
		player_move_input()
		player_roll_input()
		player_melee_input()
		player_magic_input()
		player_special_input()
	#
	player_menu_input()
#
func player_move_input() -> void:
	#CM: player_handle_input
	if is_roll == true: return
	#
	if is_melee == false:
		if is_special == false:
			var moveDirection = Input.get_vector("move_left","move_right","move_up","move_down")
			velocity = moveDirection*speed
		else:
			velocity.x = 0
			velocity.y = 0
	else:
			velocity.x = 0
			velocity.y = 0
	#
	form.player_velocity = velocity
#
func player_roll_input() -> void:
	#CM: player_handle_input
	if is_attack == false && is_swap == false:
		if is_roll == false:
			if Input.is_action_just_pressed("roll"):
				if stamina >= 50:
					stamina = stamina - 50
					velocity = velocity * 2
					is_roll = true
					is_invincible = true
					form.is_roll = true
					form.is_invincible = true
					stamina_gui.update()
#
func player_melee_input() -> void:
	#CM: player_handle_input
	if is_roll == true: return
	if is_attack == false:
		if Input.is_action_just_pressed("melee_skill"):
			is_attack = true
			is_melee = true
			form.is_attack = true
			form.is_melee = true
			form.melee_dir = player_cursor_direction()
			form.last_dir = player_cursor_direction()
#
func player_magic_input() -> void:
	#CM: player_handle_input
	if is_attack == false && is_roll == false:
		if Input.is_action_pressed("magic_skill"):
			is_attack = true
			is_magic = true
			speed = 40
			cursor.form_cursor.visible = true
			form.is_attack = true
			form.is_magic = true
			#form.magic.update()
	if is_magic == true:
		player_form_charge_update()
		form.player_velocity = velocity
		if Input.is_action_just_released("magic_skill"):
			is_attack = false
			is_magic = false
			speed = 60
			cursor.form_cursor.visible = false
			form.is_attack = false
			form.is_magic = false
			#form.magic.update()
			form.magic.is_magic == false
#
func player_special_input() -> void:
	#CM: player_handle_input
	if is_attack == false && is_roll == false:
		if Input.is_action_just_pressed("special_skill"):
			if form.t_special <= 0:
				#if player_special_use_check(form.special_cost) == true:
				player_form_charge_update()
				form.is_attack = true
				form.is_special = true
				#form.t_special = 90
				is_attack = true
				is_special = true
#
func player_menu_input() -> void:
	#CM: player_handle_input
	if Input.is_action_just_pressed("pause_game"):
		if form_menu == false:
			if pause_menu == false:
				pause_menu = true
				get_tree().paused = true
				pause_controller.toggle_menu()
#
func player_roll_collision() -> void:
	#CM: player_handle_input
	if is_roll == true:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			#print("Collided with: ", collision.get_collider().name)
			if roll_shake == false:
				camera.is_shaking = true
				camera.apply_shake(3)
				roll_shake = true
#
func player_hurt_by_enemy(area) -> void:
	#CM: _on_hit_area_area_entered
	if is_invincible == false:
		player_apply_damage(area.damage)
		if autoload_game.audio_mute == false:
			hurt_audio.play()
		camera.is_shaking = true
		camera.apply_shake(3)
		is_hurt = true
		t_hurt = 30
		form.is_hurt = true
		if area.inflict_kb == true:
			if is_knockback == false:
				is_knockback = true
				form.is_knockback = true
				autoload_entity.knockback(self,area.global_position,area.kb_power,5)
#
func player_apply_damage(_damage) -> void:
	#CM: player_hurt_by_enemy
	hp = hp - _damage
	if hp <= 0:
		player_status_reset()
		hp = max_hp
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				global_position = spawn.global_position
		dead_gui.set_visible(true)
		t_dead = 300
		is_dead = true
	health_gui.update()
#
func player_cursor_direction():
	var _cdir = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
	_cdir = wrapi(_cdir,0,360)
	if _cdir < 0:
		_cdir = 360 - _cdir
	if _cdir < 45:
			return "right"
	if _cdir >= 45:
		if _cdir < 135:
			return "down"
	if _cdir >= 135:
		if _cdir < 225:
			return "left"
	if _cdir >= 225:
		if _cdir < 315:
			return "up"
	if _cdir >= 315:
		return "right"
#
func player_update_cam_tilemap() -> void:
	#CM: Room _ready()
	camera.tilemap = tilemap
	camera.update_camera(tilemap)
#
func player_form_swap_set(_formNum,_formType) -> void:
	#CM: Form Swap Menu > _on_button_name_down
	form_id = _formNum
	form_type = _formType
	direction = form.direction
	last_dir = form.last_dir
	is_swap = true
	cursor.update(form_id)
	form.is_swap = true
	form.t_swap = 30
	form.sprite._set("is_swap",true)
	form.sprite.apply_intensity_fade(0.0,1.0,0.5)
	t_swap = 30
#
func player_form_charge_update() -> void:
	form.yellow_primary = yellow_primary
	form.violet_primary = violet_primary
	form.green_primary = green_primary
	form.blue_primary = blue_primary
	form.orange_primary = orange_primary
	form.red_primary = red_primary
	form.yellow_special = yellow_special
	form.violet_special = violet_special
	form.green_special = green_special
	form.blue_special = blue_special 
	form.orange_special = orange_special
	form.red_special = red_special
	form.yellow_max = yellow_max
	form.violet_max = violet_max
	form.green_max = green_max
	form.blue_max = blue_max
	form.orange_max = orange_max
	form.red_max = red_max
#
func player_special_timer(delta) -> void:
	#CM: 
	match form_type:
		0:
			if yellow_special < current_max:
				if t_special > 0:
					t_special = t_special - (delta * fps)
				if t_special < 1:
					t_special = 5
					yellow_special = yellow_special + ((delta * fps) * 5)
					special_gui.update()
			current_special = yellow_special
			return
		1:
			if violet_special < current_max:
				if t_special > 0:
					t_special = t_special - (delta * fps)
				if t_special < 1:
					t_special = 5
					violet_special = violet_special + (delta * fps)
					special_gui.update()
			current_special = violet_special
			return
#
func player_form_swap():
	var form_pos = form.global_position
	velocity.x = 0
	velocity.y = 0
	form.queue_free()
	form.form_status_reset()
	load_form = autoload_player.form_array[form_id]
	form = load_form.instantiate()
	add_child(form)
	form.player = self
	form.global_position = form_pos
	form.is_swap = true
	form.direction = direction
	form.last_dir = direction
	player_signal_connections()
	health_gui.update()
	stamina_gui.update()
	primary_gui.update()
	special_gui.update()
	#
	player_status_reset()
#
func player_restore_all():
	yellow_primary = yellow_max
	yellow_special = yellow_max
	violet_primary = violet_max
	violet_special = violet_max
	green_primary = green_max
	green_special = green_max
	blue_primary = blue_max
	blue_special = blue_max
	orange_primary = orange_max
	orange_special = orange_max
	red_primary = red_max
	red_special = red_max
	hp = max_hp
	stamina = max_stamina
	player_hud.gui_update_all()
#
func player_status_reset():
	is_invincible = false
	is_shielded = false
	is_swap = false
	is_hurt = false
	is_dead = false
	is_knockback = false
	is_roll = false
	is_attack = false
	is_melee = false
	is_magic = false
	is_special = false
#
func player_cursor_los_check() -> bool:
	#Check Line of Sight w/ Raycast
	#special_collision.set_collision_mask_value(6,false)
	var _playPos: Vector2 = global_position
	var _cursPos: Vector2 = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(_playPos, _cursPos)
	query.set_collision_mask(0b00000000_00000000_00000001_00000000)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result:
		return true
	else: 
		return false
#
#Signal Methods
#
func _on_hitbox_area_entered(area) -> void:
	if is_roll == true: return
	if area.name == "Hitbox": return
	if is_dead == false:
		if is_hurt == false:
			if area.targets_hit.find(self) ==  -1:
				#print_debug("Added to hit list of " + str(area.name))
				area.targets_hit.append(self)
			player_hurt_by_enemy(area)
			form.form_hit()
#
func _on_status_reset() -> void:
	player_status_reset()
#
func _on_status_set(property: StringName,value: Variant) -> void:
	set(property,value)
#
func _on_check_cost(property: StringName,value: int) -> bool:
	match property:
		"yellow_primary":
			if yellow_primary >= value:
				form.magic.cost_check = true
				return true
			else:
				form.magic.cost_check = false
				return false
		"yellow_special":
			if yellow_special >= value:
				form.special.cost_check = true
				return true
			else:
				form.special.cost_check = false
				return false
		"violet_primary":
			if violet_primary >= value:
				form.magic.cost_check = true
				return true
			else:
				form.magic.cost_check = false
				return false
		"violet_special":
			if violet_special >= value:
				form.special.cost_check = true
				return true
			else:
				form.special.cost_check = false
				return false
	return false
#
func _on_charge_use(property: StringName,value: Variant) -> bool:
	match property:
		"yellow_primary":
			if yellow_primary >= value:
				yellow_primary = yellow_primary - value
				return true
			else:
				return false
		"yellow_special":
			if yellow_special >= value:
				yellow_special = yellow_special - value
				return true
			else:
				return false
		"violet_primary":
			if violet_primary >= value:
				violet_primary = violet_primary - value
				return true
			else:
				return false
		"violet_special":
			if violet_special >= value:
				violet_special = violet_special - value
				return true
			else:
				return false
	return false
#
func _on_gui_update() -> void:
	player_hud.gui_update_all()
#
func _on_camera_shake(value) -> void:
	camera.is_shaking = true
	camera.apply_shake(value)
	cursor.form_cursor.visible = true
#
func _on_cursor_los_check() -> void:
	var _check = player_cursor_los_check()
	form.cursor_los = _check
	cursor.adavio_special_cursor(_check)
