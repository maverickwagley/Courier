#scr_cam_player
#
extends Camera2D
#
@export var tilemap: TileMap
# 
#Built-In Functions
#
func _ready():
	update_camera_room()
#
#Custom Functions
#
func update_camera_room():
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.cell_quadrant_size
	var world_size_pixels = map_rect.size * tile_size
	limit_left = 0;
	limit_right = world_size_pixels.x
	limit_top = 0;
	limit_bottom = world_size_pixels.y
