extends Control

const nodes = preload("res://scripts/node_class.gd")
var first_root = nodes.new()
var open: Array = []
var close: Array = []
var store: Array = []
var curr_node = nodes.new()
var to_node = nodes.new()
@onready var cheat: Control = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var search_bot: CharacterBody2D = $"../search_bot"
@onready var goal: Area2D = $"../goal"

func _on_resume_button_pressed() -> void:
	cheat.hide()
	
	player.pause_player()

func _on_bfs_pressed() -> void:
	cheat.hide()
	get_first_root()
	search_stored(curr_node,first_root.position)
	node_to_close()
	open.pop_front()
	to_node.position = open.front()
	search_stored(to_node,to_node.position)
	go_to_node()
	player.pause_player()
	

func _on_dfs_pressed() -> void:
	cheat.hide()

func check_node_up(node):
	return search_bot.position.x == node.x && search_bot.position.y - 32 == node.y
func check_node_down(node):
	return search_bot.position.x == node.x && search_bot.position.y + 32 == node.y
func check_node_left(node):
	return search_bot.position.x - 32 == node.x && search_bot.position.y == node.y
func check_node_right(node):
	return search_bot.position.x + 32 == node.x && search_bot.position.y == node.y
func is_a_root():
	var count: int = 0
	if !search_bot.is_wall_up() && !open.any(check_node_up) && !close.any(check_node_up):
		count += 1
	if !search_bot.is_wall_down() && !open.any(check_node_down) && !close.any(check_node_down):
		count += 1
	if !search_bot.is_wall_left() && !open.any(check_node_left) && !close.any(check_node_left):
		count += 1
	if !search_bot.is_wall_right() && !open.any(check_node_right) && !close.any(check_node_right):
		count += 1
	return count > 1
func update_search_bot():
	search_bot.position.x = player.position.x
	search_bot.position.y = player.position.y
func search_stored(_node,positions):
	for i in range(store.size()):
		if store[i].position == positions:
			_node = store[i]
func get_first_root():
	first_root.position.x = player.position.x
	first_root.position.y = player.position.y
	first_root.is_root = true
	first_root.root = null
	store.append(first_root)
	open.append(first_root.position)
func node_to_open(direction):
		var new_node = nodes.new()
		new_node.position.x = search_bot.position.x
		new_node.position.y = search_bot.position.y
		new_node.is_root = is_a_root()
		if curr_node.is_root:
			new_node.root = curr_node.position
			new_node.root_to_this_node.append(direction)
		else:
			new_node.root = curr_node.root
			new_node.root_to_this_node = curr_node.root_to_this_node.duplicate(true)
			new_node.root_to_this_node.append(direction)
		store.append(new_node)
		open.append(new_node.position)
func node_to_close():
	if !player.is_wall_up() && !open.any(check_node_up) && !close.any(check_node_up):
		update_search_bot()
		search_bot.move_up()
		node_to_open("u")
	if !player.is_wall_left() && !open.any(check_node_left) && !close.any(check_node_left):
		update_search_bot()
		search_bot.move_left()
		node_to_open("l")
	if !player.is_wall_right() && !open.any(check_node_right) && !close.any(check_node_right):
		update_search_bot()
		search_bot.move_right()
		node_to_open("r")
	if !player.is_wall_down() && !open.any(check_node_down) && !close.any(check_node_down):
		update_search_bot()
		search_bot.move_down()
		node_to_open("d")
	close.append(curr_node.position)
func is_a_root_of():
	var flag: bool = false
	var temp = nodes.new()
	search_stored(temp,to_node.position)
	while temp != first_root:
		if curr_node.position == temp.root:
			flag = true
			break
		search_stored(temp,temp.root)
	return flag
func wait(time_in_seconds: float):
	await get_tree().create_timer(time_in_seconds).timeout
func path_from_a_root_to_node(path: Array):
	var temp1: Array = []
	var temp2 = nodes.new()
	search_stored(temp2,to_node.position)
	while temp2.position != curr_node.position:
		temp1 = temp2.root_to_this_node
		temp1.reverse()
		path.append_array(temp1)
		search_stored(temp2,temp2.root)
	path.reverse()
func move_down_to(path: Array):
	for i in range(path.size()):
		await get_tree().create_timer(0.25).timeout
		match path[i]:
			"u":
				player.move_up()
			"d":
				player.move_down()
			"l":
				player.move_left()
			"r":
				player.move_right()
	update_search_bot()
func reverse_to_root(path: Array):
	path = curr_node.root_to_this_node.duplicate(true)
	path.reverse()
	for move in path:
		await get_tree().create_timer(0.25).timeout
		match move:
			"u":
				player.move_down()
			"d":
				player.move_up()
			"l":
				player.move_right()
			"r":
				player.move_left()
	search_stored(curr_node,curr_node.root)
	update_search_bot()
func go_to_node():
	if is_a_root_of():
		var path: Array = []
		path_from_a_root_to_node(path)
		move_down_to(path)
		search_stored(curr_node,to_node.position)
	else:
		var path: Array = []
		reverse_to_root(path)
		go_to_node()
