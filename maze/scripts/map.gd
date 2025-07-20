extends TileMapLayer
@onready var map_layer: TileMapLayer = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var win: Control = $"../win"
@onready var goal_zone: Area2D = $goal

var is_in_goal:= false
var path_count: int = 0
var map: Array[int]
var path: Array[int]
var ver_max: int
var hoz_max: int
var goal_global: Vector2
var goal: Vector2i
const GOAL = 3
class point:
	var x: int #horizontal position
	var y: int #vertical position
	var parent: point #previous node
	func _init(_x: int,_y: int, _parent: point):
		self.x = _x
		self.y = _y
		self.parent = _parent
	func get_parent():
		return self.parent

func _on_goal_body_entered(body: Node2D) -> void:
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
			map.append(1)
		if string[i] == '0':
			map.append(0)
		if string[i] == '3':
			map.append(3)
		i = i + 1
	path.resize(map.size())
	path.fill(0)

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
			if map[i] == 1:
				map_layer.set_cell(coords,1,atlas_coords,0)
			if map[i] == 0 || map[i] == -1:
				map_layer.set_cell(coords,2,atlas_coords,0)
			if map[i] == 3:
				map_layer.set_cell(coords,2,atlas_coords,0)
				goal_global.x = coords.x * 32 + 16
				goal_zone.position.x = goal_global.x
				goal.x = h 
				goal_global.y = coords.y * 32 + 16
				goal_zone.position.y = goal_global.y
				goal.y = v
			i = i + 1

func clear_path():
	path.fill(0)
	print_map(ver_max,hoz_max)
	path_count = 0

func clear_map():
	var i = 0
	while i < map.size():
		if map[i] == -1: map[i] = 0
		i = i + 1

func is_in(p_x,p_y,array):
	for member in array:
		if p_x == member.x && p_y == member.y: return 1
	return 0

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
		path[p.y*hoz_max + p.x] = 1 #save position from goal to path
		p = p.parent

func print_path():
	var coords := Vector2i(1,1)
	var atlas_coords := Vector2i(0,0)
	var i := 0
	print(path_count)
	for v in range(ver_max):
		for h in range(hoz_max):
			coords.x = h + 1
			coords.y = v + 1
			if path[i] == 1:
				map_layer.set_cell(coords,4,atlas_coords,0)
			i = i + 1

func is_free(x,y):
	if  x < hoz_max && y < ver_max &&(map[y*hoz_max + x] == 0 || map[y*hoz_max + x] == GOAL):
		return true
	return false

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
		path[p.y*hoz_max + p.x] = 1
		p = p.parent

var hasVisited:= []
func generate_map(ver,hoz):
	hoz_max = hoz
	ver_max = ver
	map.resize(hoz * ver)
	map.fill(1)
	path.resize(hoz * ver)
	path.fill(0)
	hasVisited.append(Vector2i(1,1))
	visit(1,1)
	map[(ver_max - 1) * hoz_max + hoz_max - 2] = GOAL
func visit(y,x):
	map[y * hoz_max + x ] = 0
	while true:
		var unvisited_neighbors:= []
		if y > 1 && !hasVisited.has(Vector2i(y - 2, x)):
			unvisited_neighbors.append('u')
		if y < ver_max - 2 && !hasVisited.has(Vector2i(y + 2, x)):
			unvisited_neighbors.append('d')
		if x > 1 && !hasVisited.has(Vector2i(y, x - 2)):
			unvisited_neighbors.append('l')
		if x < hoz_max - 2 && !hasVisited.has(Vector2i(y, x + 2)):
			unvisited_neighbors.append('r')
		if unvisited_neighbors.size() == 0:
			return
		else:
			var next_intersection = unvisited_neighbors.pick_random()
			var next_x = 0
			var next_y = 0
			if next_intersection == 'u':
				next_y = y - 2
				next_x = x
				map[(y - 1) * hoz_max + x] = 0
			elif next_intersection == 'd':
				next_y = y + 2
				next_x = x
				map[(y + 1) * hoz_max + x] = 0
			elif next_intersection == 'l':
				next_y = y
				next_x = x - 2
				map[y * hoz_max + x - 1] = 0
			elif next_intersection == 'r':
				next_y = y
				next_x = x + 2
				map[y * hoz_max + x + 1] = 0
			hasVisited.append(Vector2i(next_y,next_x))
			visit(next_y,next_x)
