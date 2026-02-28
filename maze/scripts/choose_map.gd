extends Control
@onready var map: TileMapLayer = $"../map"
@onready var choose_map: Control = $"."
@onready var player: CharacterBody2D = $"../player"





func _on_easy_pressed() -> void:
	var file = FileAccess.open("res://map/map_1.txt", FileAccess.READ)
	var content = file.get_as_text()
	map.save_to_map(content)
	map.print_map(21,21)
	file.close()
	choose_map.hide()
	player.pause_player()

func _on_normal_pressed() -> void:
	var file = FileAccess.open("res://map/map_2.txt", FileAccess.READ)
	var content = file.get_as_text()
	map.save_to_map(content)
	map.print_map(31,31)
	file.close()
	choose_map.hide()
	player.pause_player()


func _on_hard_pressed() -> void:
	var file = FileAccess.open("res://map/map_3.txt", FileAccess.READ)
	var content = file.get_as_text()
	map.save_to_map(content)
	map.print_map(31,57)
	file.close()
	choose_map.hide()
	player.pause_player()


func _on_random_pressed() -> void:
	var rand_ver = randi_range(5,31)
	var rand_hoz = randi_range(5,57)
	if rand_hoz % 2 == 0:
		rand_hoz = rand_hoz + 1
	if rand_ver % 2 == 0:
		rand_ver = rand_ver + 1
	map.generate_map(rand_ver,rand_hoz)
	map.print_map(rand_ver,rand_hoz)
	choose_map.hide()
	player.pause_player()
