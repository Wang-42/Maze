extends Control

@onready var cheat: Control = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var search: Node = $"../search"

func _on_resume_button_pressed() -> void:
	cheat.hide()
	player.pause_player()

func _on_bfs_pressed() -> void:
	cheat.hide()
	search.bfs()
	player.pause_player()

func _on_dfs_pressed() -> void:
	cheat.hide()
