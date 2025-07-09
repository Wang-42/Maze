extends TileMapLayer
@onready var map_layer: TileMapLayer = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var win: Control = $"../win"

var map: Array[int]
var path: Array[int]
var ver_max: int
var hoz_max: int
var goal_global: Vector2
var goal: Vector2i

func _input(event: InputEvent) -> void:
	if player.position.x == goal_global.x && player.position.y == goal_global.y:
		win.show()
		player.pause_player()
		if event.is_action_pressed("pause"): 
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
			if map[i] == 0:
				map_layer.set_cell(coords,2,atlas_coords,0)
			if map[i] == 3:
				map_layer.set_cell(coords,2,atlas_coords,0)
				goal_global.x = coords.x * 32 + 16
				goal.x = h 
				print(goal.x)
				goal_global.y = coords.y * 32 + 16
				goal.y = v
				print(goal.y)
			i = i + 1

func dfs(x,y):
	if x < 0 || y < 0 || x >= hoz_max || y >= ver_max: return 0
	if map[y*hoz_max + x] == 1 || path[y*hoz_max + x] == 1: return 0
	path[y*hoz_max + x] = 1
	if x == goal.x && y == goal.y: return 1
	if dfs(x + 1,y): return 1
	if dfs(x,y + 1): return 1
	if dfs(x - 1,y): return 1
	if dfs(x,y - 1): return 1
	path[y*hoz_max + x] = 0
	return 0

func print_path():
	var coords := Vector2i(1,1)
	var atlas_coords := Vector2i(0,0)
	var i := 0

	for v in range(ver_max):
		for h in range(hoz_max):
			coords.x = h + 1
			coords.y = v + 1
			if path[i] == 1:
				print("yes")
				#map_layer.erase_cell(coords)
				map_layer.set_cell(coords,4,atlas_coords,0)
			i = i + 1
