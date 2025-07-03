extends CharacterBody2D
@onready var ray_cast_down: RayCast2D = $RayCast_down
@onready var ray_cast_up: RayCast2D = $RayCast_up
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right

var paused : bool = false

func move_up():
	position.y -= 32
func move_down():
	position.y += 32
func move_left():
	position.x -= 32
func move_right():
	position.x += 32
func is_wall_up():
	return ray_cast_up.is_colliding()
func is_wall_down():
	return ray_cast_down.is_colliding()
func is_wall_left():
	return ray_cast_left.is_colliding()
func is_wall_right():
	return ray_cast_right.is_colliding()
func count_branches():
	var a: int = 0
	if is_wall_down():
		a += 1
	if is_wall_left():
		a += 1
	if is_wall_right():
		a += 1
	if is_wall_up():
		a += 1
	return a

func pause_player():
	paused = !paused

func _input(event):
	if event.is_action_pressed("move_up") && !is_wall_up() && !paused:
		move_up()
	if event.is_action_pressed("move_down") && !is_wall_down() && !paused:
		move_down()
	if event.is_action_pressed("move_left") && !is_wall_left() && !paused:
		move_left()
	if event.is_action_pressed("move_right") && !is_wall_right() && !paused:
		move_right()
