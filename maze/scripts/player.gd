extends CharacterBody2D
@onready var ray_cast_down: RayCast2D = $RayCast_down
@onready var ray_cast_up: RayCast2D = $RayCast_up
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right


func move_up():
	position.y -= 32
func move_down():
	position.y += 32
func move_left():
	position.x -= 32
func move_right():
	position.x += 32


func _input(event):
	if event.is_action_pressed("move_up") && !ray_cast_up.is_colliding():
		move_up()
	if event.is_action_pressed("move_down") && !ray_cast_down.is_colliding():
		move_down()
	if event.is_action_pressed("move_left") && !ray_cast_left.is_colliding():
		move_left()
	if event.is_action_pressed("move_right") && !ray_cast_right.is_colliding():
		move_right()
