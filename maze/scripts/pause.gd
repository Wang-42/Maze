extends Control
@onready var pause: Control = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var map: TileMapLayer = $"../map"




func _on_resume_pressed() -> void:
	pause.hide()
	player.pause_player()

func _on_cheat_pressed() -> void:
	map.dfs((int(player.position.x) - 16)/32 - 1,(int(player.position.y) - 16)/32 - 1)
	map.print_path()
	pause.hide()
	player.pause_player()

func _on_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scences/main_menu.tscn")
