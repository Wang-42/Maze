extends TileMapLayer
@onready var map_layer: TileMapLayer = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var win: Control = $"../win"
@onready var goal_zone: Area2D = $goal

const GOAL = 3
const WALL = 1
const PATH = 0
var is_in_goal:= false
var map: Array[int]
var path: Array[int]
var path_count: int = 0
var ver_max: int
var hoz_max: int
class point:
	var x: int #horizontal position
	var y: int #vertical position
	var parent: point #previous node
	func _init(_x: int,_y: int, _parent: point):
		self.x = _x
		self.y = _y
		self.parent = _parent

func _on_goal_body_entered(_body: Node2D) -> void:
	win.show()
	is_in_goal = true
	player.velocity = Vector2(0,0)
	player.pause_player()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && is_in_goal: 
		get_tree().change_scene_to_file("res://scences/main_menu.tscn")

func save_to_map(string):
	var i := 0
	while string[i] != '4':
		if string[i] == '1':
			map.append(WALL)
		if string[i] == '0':
			map.append(PATH)
		if string[i] == '3':
			map.append(GOAL)
		i = i + 1
	path.resize(map.size())
	path.fill(WALL)

func print_map(ver,hoz):
	var coords := Vector2i(1,1)
	var atlas_coords := Vector2i(0,0)
	var i := 0
	ver_max = ver
	hoz_max = hoz
	for v in range(ver):
		for h in range(hoz):
			coords.x = h + 1
			coords.y = v + 1
			if map[i] == WALL:
				map_layer.set_cell(coords,1,atlas_coords,0)
			if map[i] == PATH:
				map_layer.set_cell(coords,2,atlas_coords,0)
			if map[i] == GOAL:
				map_layer.set_cell(coords,2,atlas_coords,0)
				goal_zone.position.x = coords.x * 32 + 16
				goal_zone.position.y = coords.y * 32 + 16
			i = i + 1

func print_path():
	var coords := Vector2i(1,1)
	var atlas_coords := Vector2i(0,0)
	var i := 0
	print(path_count)
	for v in range(ver_max):
		for h in range(hoz_max):
			coords.x = h + 1
			coords.y = v + 1
			if path[i] == PATH:
				map_layer.set_cell(coords,4,atlas_coords,0)
			i = i + 1

func clear_path():
	path.fill(WALL)
	print_map(ver_max,hoz_max)
	path_count = 0

func is_in(p_x,p_y,array):
	for member in array:
		if p_x == member.x && p_y == member.y: return 1
	return 0

func is_free(x,y):
	if  x < hoz_max && y < ver_max && (map[y*hoz_max + x] == PATH || map[y*hoz_max + x] == GOAL):
		return true
	return false

func get_path_dfs(x,y): # x, y is player curr position in tilemap
	var stack = []
	var close = []
	var p = point.new(x,y,null)
	stack.append(p) #add current position to stack
	while !stack.is_empty():
		p = stack.pop_back() #pop last position
		close.append(p) #add to close
		if (map[p.y*hoz_max + p.x] == GOAL): # ~ map[p.y][p.x] 
			break
		if is_free(p.x,p.y - 1) && !is_in(p.x,p.y - 1,close) && !is_in(p.x,p.y - 1,stack): #check position above
			var nextP = point.new(p.x,p.y - 1,p)
			stack.append(nextP)
		if is_free(p.x - 1,p.y) && !is_in(p.x - 1,p.y,close) && !is_in(p.x - 1,p.y,stack): #check position left
			var nextP = point.new(p.x - 1,p.y,p)
			stack.append(nextP)
		if is_free(p.x + 1,p.y) && !is_in(p.x + 1,p.y,close) && !is_in(p.x + 1,p.y,stack): #check position right
			var nextP = point.new(p.x  + 1,p.y,p)
			stack.append(nextP)
		if is_free(p.x,p.y + 1) && !is_in(p.x,p.y + 1,close) && !is_in(p.x,p.y + 1,stack): #check position below
			var nextP = point.new(p.x,p.y + 1,p)
			stack.append(nextP)
	while p.parent != null:
		path_count = path_count + 1
		path[p.y*hoz_max + p.x] = PATH #save to path
		p = p.parent

func get_path_bfs(x,y):
	var queue = []
	var close = []
	var p = point.new(x,y,null)
	queue.append(p) #add curr position to queue
	while !queue.is_empty():
		p = queue.pop_front() #pop first position
		close.append(p)
		if (map[p.y*hoz_max + p.x] == GOAL):
			break
		if is_free(p.x,p.y - 1) && !is_in(p.x,p.y - 1,close) && !is_in(p.x,p.y - 1,queue):
			var nextP = point.new(p.x,p.y - 1,p)
			queue.append(nextP)
		if is_free(p.x - 1,p.y) && !is_in(p.x - 1,p.y,close) && !is_in(p.x - 1,p.y,queue):
			var nextP = point.new(p.x - 1,p.y,p)
			queue.append(nextP)
		if is_free(p.x + 1,p.y) && !is_in(p.x + 1,p.y,close) && !is_in(p.x + 1,p.y,queue):
			var nextP = point.new(p.x  + 1,p.y,p)
			queue.append(nextP)
		if is_free(p.x,p.y + 1) && !is_in(p.x,p.y + 1,close) && !is_in(p.x,p.y + 1,queue):
			var nextP = point.new(p.x,p.y + 1,p)
			queue.append(nextP)
	while p.parent != null:
		path_count = path_count + 1
		path[p.y*hoz_max + p.x] = PATH
		p = p.parent










func generate_map(ver,hoz):
	hoz_max = hoz
	ver_max = ver
	map.resize(hoz * ver)
	map.fill(WALL)
	path.resize(hoz * ver)
	path.fill(WALL)
	var hasVisited:= []
	var stack:= []
	hasVisited.append(Vector2i(hoz_max - 2,1))
	stack.append(Vector2i(hoz_max - 2,1))
	var curr_cell: Vector2i
	while !stack.is_empty():
		curr_cell = stack.pop_back()
		map[curr_cell.y * hoz_max + curr_cell.x] = PATH
		var unvisited_neighbors:= []
		if curr_cell.y > 1 && !hasVisited.has(Vector2i(curr_cell.x, curr_cell.y - 2)):
			unvisited_neighbors.append('u')
		if curr_cell.y < ver_max - 2 && !hasVisited.has(Vector2i(curr_cell.x, curr_cell.y + 2)):
			unvisited_neighbors.append('d')
		if curr_cell.x > 1 && !hasVisited.has(Vector2i(curr_cell.x - 2, curr_cell.y)):
			unvisited_neighbors.append('l')
		if curr_cell.x < hoz_max - 2 && !hasVisited.has(Vector2i(curr_cell.x + 2, curr_cell.y)):
			unvisited_neighbors.append('r')
		if unvisited_neighbors.size() > 0:
			stack.append(curr_cell)
			var next_intersection = unvisited_neighbors.pick_random()
			var next_x = 0
			var next_y = 0
			if next_intersection == 'u':
				next_y = curr_cell.y - 2
				next_x = curr_cell.x
				map[(curr_cell.y - 1) * hoz_max + curr_cell.x] = PATH
			elif next_intersection == 'd':
				next_y = curr_cell.y + 2
				next_x = curr_cell.x
				map[(curr_cell.y + 1) * hoz_max + curr_cell.x] = PATH
			elif next_intersection == 'l':
				next_y = curr_cell.y
				next_x = curr_cell.x - 2
				map[curr_cell.y * hoz_max + curr_cell.x - 1] = PATH
			elif next_intersection == 'r':
				next_y = curr_cell.y
				next_x = curr_cell.x + 2
				map[curr_cell.y * hoz_max + curr_cell.x + 1] = PATH
			hasVisited.append(Vector2i(next_x,next_y))
			stack.append(Vector2i(next_x,next_y))
	map[(ver_max - 1) * hoz_max + hoz_max - 2] = GOAL
