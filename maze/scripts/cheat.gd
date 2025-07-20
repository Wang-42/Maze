extends Control

@onready var player: CharacterBody2D = $"../player"
@onready var map: TileMapLayer = $"../map"
@onready var cheat: Control = $"."




func _on_bfs_pressed() -> void:
	map.get_path_bfs((int(player.position.x) - int(player.position.x) % 32)/32 - 1
					,(int(player.position.y) - int(player.position.y) % 32)/32 - 1)
	map.print_path()
	cheat.hide()
	player.pause_player()



func _on_dfs_pressed() -> void:
	map.get_path_dfs((int(player.position.x) - int(player.position.x) % 32)/32 - 1
					,(int(player.position.y) - int(player.position.y) % 32)/32 - 1)
	map.print_path()
	cheat.hide()
	player.pause_player()
