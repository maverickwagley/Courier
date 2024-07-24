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
				#hurtBlink.texture = value
			"offset":
				silhouette.offset = value
				#hurtBlink.offset = value
			"flip_h":
				silhouette.flip_h = value
				#hurtBlink.flip_h = value
			"flip_v":
				silhouette.flip_v = value
				#hurtBlink.flip_v = value
			"hframes":
				silhouette.hframes = value
				#hurtBlink.hframes = value
			"vframes":
				silhouette.vframes = value
				#hurtBlink.vframes = value
			"frame":
				silhouette.frame = value
				#hurtBlink.frame = value
			"frame_coords":
				silhouette.frame_coords = value
				#hurtBlink.frame_coords = value
			"is_hurt":
				if value == false:
					silhouette.material.set_shader_parameter("active",true)
					#hurtBlink.material.set_shader_parameter("active",false)
				else:
					silhouette.material.set_shader_parameter("active", false)
					#hurtBlink.material.set_shader_parameter("active",true)
			"is_swap":
				if value == false:
					silhouette.material.set_shader_parameter("active",true)
				else:
					silhouette.material.set_shader_parameter("active", false)
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
func apply_hurt():
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blinkIntensity,1.0,0.0,0.5)
#
func set_shader_blinkIntensity(_newValue: float) -> void:
	material.set_shader_parameter("blink_intensity", _newValue)
