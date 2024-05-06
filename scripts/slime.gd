extends CharacterBody2D


@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right_down = $RayCastRightDown
@onready var ray_cast_left_down = $RayCastLeftDown
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 60
var direction = 1

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if ray_cast_right.is_colliding() || !ray_cast_right_down.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding() || !ray_cast_left_down.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta

