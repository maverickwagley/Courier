#Enemy Sprite
#
extends Sprite2D
#
@export var is_hurt: bool = false
#
#Built-In Methods
#
func _set(property: StringName, value: Variant) -> bool:
	match property:
		"is_hurt":
			if value == false:
				material.set_shader_parameter("is_hurt",false)
			else:
				material.set_shader_parameter("is_hurt",true)
	return false
#
#Custom Methods
#
func apply_intensity_fade(_start,_finish,_length) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blinkIntensity,_start,_finish,_length)
#
func set_shader_blinkIntensity(_newValue: float) -> void:
	material.set_shader_parameter("blink_intensity", _newValue)
