#scr_autoload_enemy
#
extends Node
#
#Custom Methods
#
func knockback(_receiveKB: CharacterBody2D, _kbSourcePos: Vector2, _power: int, _dur : int):
	var receiver = _receiveKB
	var knockback_dir = _kbSourcePos.direction_to(receiver.global_position)
	receiver.knockback_power = _power
	receiver.velocity = knockback_dir * _power
	receiver.t_knockback = _dur
	receiver.is_knockback = true
	#source.move_and_slide()
#
func set_status():
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
