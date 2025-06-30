extends Control
@onready var main = $"../"


func _on_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://scences/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	main.pauseMenu()
