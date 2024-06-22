extends Control

@export var server_ip = "127.0.0.1"
@export var server_port = 8080
var server_peer = ENetMultiplayerPeer.new()
#
#Built-in Methods
#
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
#
func _process(delta):
	pass
#
#Custom Methods
#
func peer_connected(id):
	print("Player Connected:" + str(id))
#
func peer_disconnected(id):
	print("Player Disconnected:" + str(id))
#
func connected_to_server():
	print("Connected to Server!")
	send_player_info.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())
#
func connection_failed():
	print("Connection Failed")
#
func _on_host_button_down():
	print_debug("Starting host!")
	server_peer = ENetMultiplayerPeer.new()
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	send_player_info($LineEdit.text, multiplayer.get_unique_id())
	#old version
	#peer = ENetMultiplayerPeer.new()
	#var error = peer.create_server(port, 4)
	#if error != OK:
		#print("Cannot Host:" + error)
		#return
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	#multiplayer.set_multiplayer_peer(peer)
	#print("Waiting for players...")
	#send_player_info($LineEdit.text, multiplayer.get_unique_id())
#
func _on_join_button_down():
	print_debug("Player 2 joining")
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(server_ip,server_port)
	multiplayer.multiplayer_peer = client_peer
	send_player_info($LineEdit.text, multiplayer.get_unique_id())
	#server_peer = ENetMultiplayerPeer.new()
	#server_peer.create_client(ip_address, port)
	#server_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	#multiplayer.set_multiplayer_peer(server_peer)
#
func _add_player_to_game(id: int):
	print_debug("Player %s joined the game!" % id)

#
func _del_player(id: int):
	print_debug("Player %s left the game!" % id)
#
func _on_start_button_down():
	start_game.rpc()
#
#RPC Methods
#
@rpc("any_peer")
func send_player_info(name, id):
	if !ScrGameManager.player.has(id):
		ScrGameManager.player[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server():
		for i in ScrGameManager.player:
			send_player_info.rpc(ScrGameManager.player[i].name, i)
#
@rpc("any_peer", "call_local")
func start_game():
	#var game_scene = load("res://Scenes/Room/Lenko/rm_world.tscn").instantiate()
	get_tree().change_scene_to_file("res://Scenes/Room/LenkoRooms/rm_farway.tscn")
	#get_tree().root.add_child(game_scene)
	#self.hide()
