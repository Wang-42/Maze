extends Node

@onready var player: CharacterBody2D = $"../player"
@onready var search_bot: CharacterBody2D = $"../search_bot"
@onready var goal: Area2D = $"../goal"

class nodes:
	var positions: Vector2
	var is_root: bool = false
	var root_to_this_node: Array = []
	var root: Vector2

var open: Array = []
var close: Array = []
var stored: Array = []
var curr_node = nodes.new()
var to_node = nodes.new()
var first_root = nodes.new()

func bfs():
	open.clear()
	close.clear()
	stored.clear()
	get_first_root()
	curr_node = copy_from_stored(first_root.positions)
	node_to_close()
	open.pop_front()
	to_node = copy_from_stored(open.front())
	go_to_node()


func wait(time_in_seconds: float):
	await get_tree().create_timer(time_in_seconds).timeout

func update_search_bot():
	search_bot.position = player.position

func get_first_root():
	first_root.positions.x = search_bot.position.x
	first_root.positions.y = search_bot.position.y
	first_root.is_root = true
	#first_root.root = null
	stored.append(first_root)
	open.append(first_root.positions)

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

func copy_from_stored(positions):
	for i in range(stored.size()):
		if stored[i].positions == positions:
			return stored[i]

func node_to_open(direction):
	var new_node = nodes.new()
	new_node.positions.x = search_bot.position.x
	new_node.positions.y = search_bot.position.y
	new_node.is_root = is_a_root()
	new_node.root_to_this_node.clear()
	if curr_node.is_root:
		new_node.root = curr_node.positions
		new_node.root_to_this_node.append(direction)
	else:
		new_node.root = curr_node.root
		new_node.root_to_this_node = curr_node.root_to_this_node.duplicate(true)
		new_node.root_to_this_node.append(direction)
	stored.append(new_node)
	open.append(new_node.positions)

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
	close.append(curr_node.positions)

func is_a_root_of():
	var temp = nodes.new()
	temp = copy_from_stored(to_node.positions)
	while temp.positions != null:
		if curr_node.positions == temp.root:
			return true
		temp = copy_from_stored(to_node.root)
	return false

func path_from_a_root_to_node(path: Array):
	var temp_1: Array  = []
	var temp_2 = nodes.new()
	temp_2 = copy_from_stored(to_node.positions)
	while temp_2.positions != curr_node.positions:
		temp_1 = temp_2.root_to_this_node.duplicate(true)
		temp_1.reverse()
		path.append_array(temp_1)
		temp_2 = copy_from_stored(temp_2.root)
	path.reverse()

func move_down_to(path: Array):
	for i in range(path.size()):
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

func reverse_to_root():
	var path: Array = []
	path = curr_node.root_to_this_node.duplicate(true)
	path.reverse()
	for move in path:
		match move:
			"u":
				player.move_down()
			"d":
				player.move_up()
			"l":
				player.move_right()
			"r":
				player.move_left()
	curr_node = copy_from_stored(curr_node.root)
	update_search_bot()

func go_to_node():
	if is_a_root_of():
		var path: Array = []
		path_from_a_root_to_node(path)
		move_down_to(path)
		curr_node = copy_from_stored(to_node.positions)
	else:
		reverse_to_root()
		go_to_node()
