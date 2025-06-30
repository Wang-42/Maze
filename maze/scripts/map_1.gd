extends Node2D
@onready var pause: Control = $pause
@onready var player: CharacterBody2D = $player

var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause.hide()
		Engine.time_scale = 1
	else:
		pause.show()
		Engine.time_scale = 0
	paused = !paused
	
