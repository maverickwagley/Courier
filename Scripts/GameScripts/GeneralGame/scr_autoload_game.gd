extends Node
#9223372008786492141

#General Game
var player = {}
var mode: int = 0
var room: Node2D
var fps_target: int = 60
#Wave Based Game
var local_wave: int = 1
var game_wave: int = 1
var enemy_count: int = 0
#Settings
var audio_mute: bool = true
