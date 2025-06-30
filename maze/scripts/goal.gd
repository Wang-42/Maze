extends Area2D


func _on_body_entered(_body):
	queue_free()
	get_tree().change_scene_to_file("res://scences/main_menu.tscn")
