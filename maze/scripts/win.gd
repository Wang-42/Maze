extends Control

@onready var win: Control = $"."
@onready var goal: Area2D = $"../goal"

var flag : bool = false

func _on_goal_body_entered(_body: Node2D) -> void:
	win.show()
	flag = !flag
func _input(event):
	if flag && event.is_action_pressed("space"):
		flag = !flag
		queue_free()
		get_tree().change_scene_to_file("res://scences/main_menu.tscn")
