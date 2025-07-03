extends Control

@onready var pause: Control = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var cheat: Control = $"../cheat"
var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause.hide()
		player.pause_player()
	else:
		pause.show()
		player.pause_player()
	paused = !paused
	

func _on_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://scences/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	pauseMenu()

func _on_cheat_pressed() -> void:
	pauseMenu()
	player.pause_player()
	cheat.show()
	
