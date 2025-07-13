extends TileMapLayer
@onready var map_layer: TileMapLayer = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var win: Control = $"../win"

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


func _input(event: InputEvent) -> void:
	if player.position.x == goal_global.x && player.position.y == goal_global.y:
		win.show()
		is_in_goal = true
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
				goal.x = h 
				goal_global.y = coords.y * 32 + 16
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
