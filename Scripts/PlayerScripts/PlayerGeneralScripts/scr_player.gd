#Player
#
extends CharacterBody2D
#Prep Nodes
@onready var camera: Camera2D = $Camera2D
@onready var hurt_box: Area2D = $Hitbox
@onready var player_hud: CanvasLayer = $PlayerHUD
@onready var health_gui: TextureProgressBar = $PlayerHUD/HealthBar
@onready var stamina_gui: TextureProgressBar = $PlayerHUD/StaminaBar
@onready var primary_gui: TextureProgressBar = $PlayerHUD/PrimaryBar
@onready var special_gui: TextureProgressBar = $PlayerHUD/SpecialBar
@onready var dead_gui: Label = $PlayerHUD/DeadLabel
@onready var dead_timer: Timer = $PlayerHUD/DeadTimer
@onready var form_controller: CanvasLayer = $FormSwapMenu
@onready var form_timer: Timer = $FormSwapMenu/FormSwapTimer
@onready var pause_controller: CanvasLayer = $PauseMenu
@onready var cursor: Node2D = $Cursor/CursorManager
@onready var damage_dealt_audio: AudioStreamPlayer = $DamageSFX
@onready var hurt_audio: AudioStreamPlayer = $HurtSFX
#Room
var tilemap: TileMap 
var room_space = get_parent()
#Form
var form: Node2D
var load_form: PackedScene
var form_id: int = 0
var form_type: int = 0
#Stats
#Stats that are upgradable should be moved to autoload
var hp: int = 50
var max_hp: int = 200
var stamina: int = 200
var speed: int = 65
var max_stamina: int = 200
var yellow_primary: int = 200
var violet_primary: int = 200
var green_primary: int = 200
var blue_primary: int = 200
var orange_primary: int = 200
var red_primary: int = 200
var yellow_special: int = 200
var violet_special: int = 200
var green_special: int = 200
var blue_special: int = 200
var orange_special: int = 200
var red_special: int = 200
var yellow_max: int = 200
var violet_max: int = 200
var green_max: int = 200
var blue_max: int = 200
var orange_max: int = 200
var red_max: int = 200
var current_max: int = 200
#Status
var is_invincible: bool = false
var is_swap: bool = false
var is_hurt: bool = false
var is_dead: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
#Animation
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
#Other
var roll_shake: bool = false
var form_menu: bool = false
var pause_menu: bool = false
var _tStamina: int = 0
#
#Built-In Methods
#
func _ready() -> void:
	load_form = autoload_player.form_array[0]
	form = load_form.instantiate()
	add_child(form)
	form_controller.player_form = 0
	form_id = 0
#
func _physics_process(_delta) -> void:
	if is_dead == false:
		update_process()
		handle_input()
		menu_input()
	else:
		#death_process()
		visible = false
		if dead_timer.get_time_left() <= 0:
			is_dead = false
			is_swap = true
			dead_gui.visible = false
			form.sprite._set("is_hurt",false)
			form.form_swap_in()
			form.sprite.apply_intensity_fade(1.0,0.0,0.5)
#
#Custom Methods
#
func update_process() -> void:
	#CM: _physics_process
	visible = true
	if stamina < max_stamina:
		if _tStamina > 0:
			_tStamina = _tStamina - 1
		if _tStamina <= 0:
			_tStamina = 3
			stamina = stamina + 1
			stamina_gui.update() 
#
func handle_input() -> void:
	#CM: _phsyics_process
	if move_and_slide():
		roll_collision()
	if is_knockback == false:
		move_input()
#
func menu_input() -> void:
	if Input.is_action_just_pressed("pause_game"):
		if form_menu == false:
			if pause_menu == false:
				pause_menu = true
				get_tree().paused = true
				pause_controller.toggle_menu()
#
func move_input() -> void:
	#CM: handle_input
	if is_roll == true: return
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
func roll_collision() -> void:
	if is_roll == true:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			#print("Collided with: ", collision.get_collider().name)
			if roll_shake == false:
				camera.is_shaking = true
				camera.apply_shake(3)
				roll_shake = true
#
func hurt_by_enemy(area) -> void:
	#CM: _on_hit_area_area_entered
	apply_damage(area.damage)
	if autoload_game.audio_mute == false:
		hurt_audio.play()
	camera.is_shaking = true
	camera.apply_shake(3)
	is_hurt = true
	form.is_hurt = true
	if area.inflict_kb == true:
		if is_knockback == false:
			is_knockback = true
			form.is_knockback = true
			autoload_entity.knockback(self,area.global_position,area.kb_power,5)
#
func apply_damage(_damage) -> void:
	#CM: hurt_by_enemy
	hp = hp - _damage
	if hp <= 0:
		hp = max_hp
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				global_position = spawn.global_position
		dead_gui.set_visible(true)
		dead_timer.start()
		is_dead = true
	health_gui.update()
#
func cursor_direction():
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
func update_cam_tilemap() -> void:
	#CM: Room _ready()
	camera.tilemap = tilemap
	camera.update_camera(tilemap)
#
func form_update(_formNum,_formType) -> void:
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
	form_timer.start()
	await form_timer.timeout
	var form_pos = form.global_position
	velocity.x = 0
	velocity.y = 0
	form.queue_free()
	form.form_status_reset()
	load_form = autoload_player.form_array[_formNum]
	form = load_form.instantiate()
	add_child(form)
	form.global_position = form_pos
	form.player = self
	form.is_swap = true
	form.direction = direction
	form.last_dir = direction
	health_gui.update()
	stamina_gui.update()
	primary_gui.update()
	special_gui.update()
#
#Signal Methods
#
func _on_hitbox_area_entered(area) -> void:
	if is_roll == true: return
	if area.name == "Attack1Area": #This likely will need updated for other hitboxes
		if is_hurt == false:
			hurt_by_enemy(area)
			form.form_hit()
