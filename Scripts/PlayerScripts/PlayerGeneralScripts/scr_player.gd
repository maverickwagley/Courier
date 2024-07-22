#Player
extends CharacterBody2D

signal sig_health_changed

@export var speed: int = 65
@export var knockback_power = 50

@onready var camera = $Camera2D
@onready var hurt_box = $Hitbox
@onready var player_hud: CanvasLayer = $PlayerHUD
@onready var health_gui: TextureProgressBar = $PlayerHUD/HealthBar
@onready var stamina_gui: TextureProgressBar = $PlayerHUD/StaminaBar
@onready var primary_gui: TextureProgressBar = $PlayerHUD/PrimaryBar
@onready var special_gui: TextureProgressBar = $PlayerHUD/SpecialBar
@onready var dead_gui: Label = $PlayerHUD/DeadLabel
@onready var form_controller: CanvasLayer = $FormSwapMenu
@onready var pause_controller: CanvasLayer = $PauseMenu
@onready var cursor: CanvasLayer = $Cursor
@onready var form0 = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_regaliare.tscn")
@onready var form1 = preload("res://Scenes/PlayerScenes/AdavioScenes/ent_adavio.tscn")
@onready var form_array = [form0,form1]
@onready var form_inst = form0
@onready var current_form
@onready var player: Node2D
@onready var tilemap: TileMap 
@onready var room_space = get_parent()
#Stats
var hp: int = 200
var max_hp: int = 200
var stamina: int = 200
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
var form_id: int = 0
var form_type: int = 0
var is_invincible: bool = false
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
var cam_set: bool = false
var cam_timer: int = 30
var t1: int = 0
var t_stamina: int = 0
var t_dead: int = 300
var form_menu: bool = false
var pause_menu: bool = false
var sync_pos = Vector2(0,0)
#
#Built-In Methods
#
func _ready():
	current_form = form_inst.instantiate()
	add_child(current_form)
	form_controller.player_form = 0
	form_id = 0
#
func _physics_process(delta):
	if is_dead == false:
		update_process()
		handle_input()
		update_cam_tilemap()
		menu_input()
	else:
		t_dead = t_dead - 1
		visible = false
		if t_dead <= 0:
			is_dead = false
			t_dead = 300
			dead_gui.visible = false
			current_form.effects.play("anim_swap_in")
#
#Signal Methods
#
func _on_hitbox_area_entered(area):
	if is_knockback == true: return
	if is_roll == true: return
	if area.name == "MeleeWeapon":
		if is_hurt == false:
			hurt_by_enemy(area)
			current_form.form_hit()
#
#Custom Methods
#
func handle_input():
	#CM: _phsyics_process
	if move_and_slide():
		roll_collision()
	if is_knockback == false:
		move_input()
		if form_menu == false:
			roll_input()
			melee_input()
			magic_input()
			special_input()
#
func move_input():
	#CM: handle_input
	if is_roll == true: return
	if is_melee == false:
		if is_special == false:
			var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			velocity = moveDirection*speed
		else:
			velocity.x = 0
			velocity.y = 0
	else:
			velocity.x = 0
			velocity.y = 0
	sync_pos = global_position
	#global_position = global_position.lerp(sync_pos, .5)
#
func roll_input():
	#CM: handle_input
	if is_attack == false:
		if is_roll == false:
			if stamina >= 50:
				if Input.is_action_just_pressed("roll"):
					stamina = stamina - 50
					velocity = velocity * 2
					is_roll = true
					is_invincible = true
					current_form.is_roll = true
					current_form.is_invincible = true
					stamina_gui.update()
#
func melee_input():
	#CM: handle_input
	if is_roll == true: return
	if is_attack == false:
		if Input.is_action_just_pressed("melee_skill"):
			is_attack = true
			is_melee = true
			current_form.is_attack = true
			current_form.is_melee = true
			#if melee_aim = true
			var cdir = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
			current_form.melee_dir = ScrPlayerGeneral.cursor_direction(cdir)
			current_form.last_dir = ScrPlayerGeneral.cursor_direction(cdir)
#
func magic_input():
	#CM: handle_input
	if is_attack == false:
		if Input.is_action_pressed("magic_skill"):
			is_attack = true
			is_magic = true
			current_form.is_attack = true
			current_form.is_magic = true
			speed = 40
			current_form.magic.update()
	if is_magic == true:
		if Input.is_action_just_released("magic_skill"):
			is_attack = false
			is_magic = false
			current_form.is_attack = false
			current_form.is_magic = false
			speed = 60
			current_form.magic.update()
#
func special_input():
	#CM: handle_input
	if is_roll == true: return
	if is_attack == false:
		if Input.is_action_just_pressed("special_skill"):
			if t1 <= 0:
				t1 = 90
				is_attack = true
				is_special = true
				current_form.is_attack = true
				current_form.is_special = true
#
func knockback(_enemyDirection: Vector2):
	#CM: hurt_by_enemy
	var knockback_dir = (_enemyDirection - velocity).normalized() * knockback_power #Replace velocity with direction
	velocity = knockback_dir
	move_and_slide()
#
func roll_collision():
	if is_roll == true:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			#print("Collided with: ", collision.get_collider().name)
			if roll_shake == false:
				camera.is_shaking = true
				camera.apply_shake(3)
				roll_shake = true
#
func hurt_by_enemy(area):
	#CM: _on_hit_area_area_entered
	update_health(area.damage)
	camera.is_shaking = true
	camera.apply_shake(3)
	is_hurt = true
	current_form.is_hurt = true
	if area.inflict_kb == true:
		is_knockback = true
		current_form.is_knockback = true
	sig_health_changed.emit()
	knockback(area.get_parent().velocity) #Replace velocity with direction
#
func update_health(_damage):
	#CM: hurt_by_enemy
	hp = hp - _damage
	if hp <= 0:
		hp = max_hp
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				global_position = spawn.global_position
		dead_gui.set_visible(true)
		t_dead = 300
		is_dead = true
	health_gui.value = hp * 100 / max_hp
#
func update_process():
	#CM: _physics_process
	visible = true
	if t1 > 0:
		t1 = t1 - 1
	if stamina < max_stamina:
		if t_stamina > 0:
			t_stamina = t_stamina - 1
		if t_stamina <= 0:
			t_stamina = 3
			stamina = stamina + 1
			stamina_gui.update() 
#
func update_special():
	#CM: _physics_process
	if stamina < max_stamina:
		if t_stamina > 0:
			t_stamina = t_stamina - 1
		if t_stamina <= 0:
			t_stamina = 3
			stamina = stamina + 1
			stamina_gui.update()
#
func update_cam_tilemap():
	#CM: Spawner Script
	if cam_set == false:
		cam_timer = cam_timer - 1 
		if cam_timer <= 0:
			camera.tilemap = tilemap
			cam_set = true
#
func menu_input():
	if Input.is_action_just_pressed("pause_game"):
		if form_menu == false:
			if pause_menu == false:
				pause_menu = true
				get_tree().paused = true
				pause_controller.toggle_menu()
#
func form_update(_formNum,_formType):
	#CM: Form Swap Menu > _on_button_name_down
	form_id = _formNum
	form_type = _formType
	current_form.effects.play("anim_swap_out")
	await current_form.effects.animation_finished
	var form_pos = current_form.global_position
	velocity.x = 0
	velocity.y = 0
	current_form.queue_free()
	form_inst = form_array[_formNum]
	current_form = form_inst.instantiate()
	add_child(current_form)
	current_form.global_position = form_pos
	current_form.player = self
	health_gui.update()
	stamina_gui.update()
	primary_gui.update()
	special_gui.update()
