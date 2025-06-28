extends CharacterBody2D
@onready var ray_cast_down: RayCast2D = $RayCast_down
@onready var ray_cast_up: RayCast2D = $RayCast_up
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right

func _physics_process(_delta):
	if Input.is_action_just_pressed("move_up") && !ray_cast_up.is_colliding():
		position.y -= 50
	if Input.is_action_just_pressed("move_down") && !ray_cast_down.is_colliding():
		position.y += 50
	if Input.is_action_just_pressed("move_left") && !ray_cast_left.is_colliding():
		position.x -= 50
	if Input.is_action_just_pressed("move_right") && !ray_cast_right.is_colliding():
		position.x += 50
