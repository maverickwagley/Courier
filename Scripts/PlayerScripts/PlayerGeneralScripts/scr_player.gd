#Player - Regaliare
extends CharacterBody2D

signal sig_health_changed

@export var speed: int = 65
@export var knockback_power = 50
@export var inventory: Inventory

@onready var camera = $Camera2D
@onready var hurt_box = $Hitbox
@onready var player_hud: CanvasLayer = $PlayerHUD
@onready var health_gui: TextureProgressBar = $PlayerHUD/HealthBar
@onready var form_controller: CanvasLayer = $FormControl
@onready var form0 = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_regaliare.tscn")
@onready var form1 = preload("res://Scenes/PlayerScenes/AdavioScenes/ent_adavio.tscn")
@onready var form_array = [form0,form1]
@onready var form_inst = form0
@onready var current_form
@onready var player: Node2D
@onready var tilemap: TileMap 
@onready var room_space = get_parent()

var hp: int = 200
var max_hp: int = 200
var cam_set: bool = false
var cam_timer: int = 30
var form_id: int = 0
var t1: int = 0
var form_menu: bool = false
var is_invincible: bool = false
var is_hurt: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var sync_pos = Vector2(0,0)
#
#Built-In Methods
#
func _ready():
	#ssz_index = position.y
	current_form = form_inst.instantiate()
	add_child(current_form)
	form_controller.player_form = 0
	form_id = 0
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
#
func _physics_process(delta):
	if t1 > 0:
		t1 = t1 - 1
	if ScrGameManager.mode == 2:
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			handle_input()
	else:
		handle_input()
	move_and_slide()
	update_cam_tilemap()
	menu_input()
#
#Signal Methods
#
func _on_hitbox_area_entered(area):
	if is_knockback == true: return
	if is_roll == true: return
	if area.name == "MeleeWeapon":
		hurt_by_enemy(area)
		item_pickup(area)
		current_form.form_hit()
#
#Custom Methods
#
func handle_input():
	#CM: _phsyics_process
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
			if Input.is_action_just_pressed("roll"):
				velocity = velocity * 2
				is_roll = true
				is_invincible = true
				current_form.is_roll = true
				current_form.is_invincible = true
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
func hurt_by_enemy(area):
	#CM: _on_hit_area_area_entered
	update_health(20)
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
func item_pickup(area):
	#CM: _on_hit_area_area_entered
	pass
	if area.has_method("pick_up"):
		area.pick_up(inventory)
#
func update_health(_damage):
	#CM: hurt_by_enemy
	hp = hp - _damage
	if hp <= 0:
		hp = max_hp
	health_gui.value = hp * 100 / max_hp
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
	#CM: _physics_process
	if Input.is_action_just_pressed("switch_form"):
		if form_menu == false:
			form_menu = true
		else:
			form_menu = false
		form_controller.toggle_menu()
#
func form_update(_formNum):
	#CM: Form Control > _on_button_name_down
	current_form.effects.play("anim_swap_out")
	await current_form.effects.animation_finished
	var form_pos = current_form.global_position
	current_form.queue_free()
	form_inst = form_array[_formNum]
	current_form = form_inst.instantiate()
	add_child(current_form)
	current_form.global_position = form_pos
