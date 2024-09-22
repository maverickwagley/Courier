#Form 0: Regaliare
#
extends Form
#
#Built-In Methods
#
func _ready() -> void:
	form_id = 0
	form_swap_in()
	player = get_parent()
	#melee.player = player
	magic.player = player
	#special.player = player
	special.connect("special_end",_on_special_end)
	special.connect("check_cost",_on_check_cost)
	special.connect("player_status_set",_on_player_status_set)
	special.connect("player_gui_update",_on_player_gui_update)
	special.connect("form_status_set",_on_form_status_set)
	special.connect("player_charge_use",_on_player_charge_use)
	magic.connect("check_cost",_on_check_cost)
	magic.connect("player_status_set",_on_player_status_set)
	magic.connect("player_gui_update",_on_player_gui_update)
	magic.connect("form_status_set",_on_form_status_set)
	magic.connect("player_charge_use",_on_player_charge_use)
	magic.connect("player_camera_shake",_on_player_camera_shake)
	special_cost = special.special_cost
#
func _physics_process(delta) -> void:
	form_swap_process()
	regaliare_roll()
	regaliare_melee()
	regaliare_magic()
	regaliare_special()
	regaliare_base()
#
#Custom Methods
func regaliare_roll() -> void:
	#form_roll_input()
	if is_roll == true:
		animations.play("anim_regaliare_roll_" + last_dir)
		await animations.animation_finished
		emit_signal("status_set","is_roll",false)
		emit_signal("status_set","is_invincible",true)
		emit_signal("status_set","roll_shake",false)
		is_roll = false
		is_invincible = false
#
func regaliare_melee() -> void:
	#form_melee_input()
	if is_melee == true:
		melee.enable()
		melee.parent_velocity = Vector2(0,0)
		animations.play("anim_regaliare_slash_" + last_dir)
		await animations.animation_finished
		melee.disable()
		emit_signal("status_set","is_attack",false)
		emit_signal("status_set","is_melee",false)
		is_attack = false
		is_melee = false
#
func regaliare_magic() -> void:
	#form_magic_input()
	if is_magic == true:
		magic.is_magic = true
		magic.visible = true
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = form_cursor_direction(cdir)
		last_dir = form_cursor_direction(cdir)
		magic.last_dir = last_dir
		if animations:
			if player_velocity.length() != 0:
				animations.play("anim_regaliare_runCast_" + magic_dir)
			else:
				animations.play("anim_regaliare_idleCast_" + last_dir)
	else:
		magic.is_magic = false
		magic.visible = false
#
func regaliare_special() -> void:
	if t_special > 0:
		t_special = t_special - 1
	if is_special == true:
		animations.play("anim_regaliare_special_" + last_dir)
		await animations.animation_finished
		t_special = 60
		special.is_special = true
#
func regaliare_base() -> void:
	#CM: _physics_process
	if is_roll == true: return
	#
	if is_attack == false:
		if player_velocity.length() != 0:
			form_move_audio(18)
			direction = "down"
			last_dir = "down"
			if player_velocity.x < 0: 
				direction = "left"
				last_dir = "left"
			elif player_velocity.x > 0: 
				direction = "right"
				last_dir = "right"
			elif player_velocity.y < 0: 
				direction = "up"
				last_dir = "up"
			animations.play("anim_regaliare_walk_" + direction)
		else:
			animations.play("anim_regaliare_idle_" + last_dir)
