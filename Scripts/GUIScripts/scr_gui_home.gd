extends Control

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sp_button_button_down():
	ScrGameManager.mode = 1
	get_tree().change_scene_to_file("res://Scenes/RoomScenes/LenkoRooms/rm_farway.tscn")


func _on_mp_button_button_down():
	pass
	#ScrGameManager.mode = 2

