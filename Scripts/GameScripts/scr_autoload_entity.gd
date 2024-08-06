extends Node


func knockback(_receiveKB: CharacterBody2D, _kbSourcePos: Vector2, _power: int, _dur : int):
	var receiver = _receiveKB
	var knockback_dir = _kbSourcePos.direction_to(receiver.global_position)
	receiver.velocity = knockback_dir * _power
	receiver.kb_timer = _dur
	receiver.is_knockback = true
	#source.move_and_slide()
