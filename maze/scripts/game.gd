extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().get_root().ready
	get_tree().change_scene_to_file("res://scences/main_menu.tscn")
