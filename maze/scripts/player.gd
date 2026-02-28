extends CharacterBody2D
@onready var ray_cast_down: RayCast2D = $RayCast_down
@onready var ray_cast_up: RayCast2D = $RayCast_up
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var pause: Control = $"../pause"

var paused : bool = true

func move_up():
	if !is_wall_up():
		position.y -= 32
func move_down():
	if !is_wall_down():
		position.y += 32
func move_left():
	if !is_wall_left():
		position.x -= 32
func move_right():
	if !is_wall_right():
		position.x += 32
func is_wall_up():
	return ray_cast_up.is_colliding()
func is_wall_down():
	return ray_cast_down.is_colliding()
func is_wall_left():
	return ray_cast_left.is_colliding()
func is_wall_right():
	return ray_cast_right.is_colliding()

func pause_player():
	paused = !paused

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			pause_player()
			pause.hide()
		else:
			pause_player()
			pause.show()

const SPEED = 200
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED

func _physics_process(_delta):
	if !paused:
		get_input()
	move_and_slide()
