extends Sprite2D

@onready var silhouette: Sprite2D = $Silhouette

@export var is_hurt: bool = false
@export var is_swap: bool = false
#
#Built-In Methods
#
func _ready() -> void:
	load_shader_silhouette()
#
func _set(property: StringName, value: Variant) -> bool:
	if is_instance_valid(silhouette):
		match property:
			"texture":
				silhouette.texture = value
			"offset":
				silhouette.offset = value
			"flip_h":
				silhouette.flip_h = value
			"flip_v":
				silhouette.flip_v = value
			"hframes":
				silhouette.hframes = value
			"vframes":
				silhouette.vframes = value
			"frame":
				silhouette.frame = value
			"frame_coords":
				silhouette.frame_coords = value
			"is_hurt":
				if value == false:
					silhouette.material.set_shader_parameter("active",true)
					material.set_shader_parameter("is_hurt",false)
				else:
					silhouette.material.set_shader_parameter("active", false)
					material.set_shader_parameter("is_hurt",true)
			"is_swap":
				if value == false:
					silhouette.material.set_shader_parameter("active",true)
					material.set_shader_parameter("is_swap",false)
				else:
					silhouette.material.set_shader_parameter("active", false)
					material.set_shader_parameter("is_swap",true)
	return false
#
#Custom Methods
#
func load_shader_silhouette() -> void:
	silhouette.texture = texture
	silhouette.offset = offset
	silhouette.flip_h = flip_h
	silhouette.flip_v = flip_v
	silhouette.hframes = hframes
	silhouette.vframes = vframes
	silhouette.frame_coords = frame_coords
	silhouette.frame = frame
	silhouette.material.set_shader_parameter("active",true)
#
func apply_intensity_fade(_start,_finish,_length):
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blinkIntensity,_start,_finish,_length)
#
func set_shader_blinkIntensity(_newValue: float) -> void:
	material.set_shader_parameter("blink_intensity", _newValue)
