extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var exit_timer = $CoyoteArea/ExitTimer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var near_floor = true
var on_floor_soon = false
var jump_on_landing = false

func _on_coyote_area_body_entered(body):
	near_floor = true
	on_floor_soon = true

func _on_coyote_area_body_exited(body):
	if !exit_timer.is_stopped() && !is_on_floor():
		exit_timer.start(0.2)

func _on_timer_timeout():
	near_floor = false

func on_floor():
	return near_floor || is_on_floor()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and on_floor():
		velocity.y = JUMP_VELOCITY
		near_floor = false
		exit_timer.stop()
	elif Input.is_action_just_pressed("jump") and on_floor_soon:
		jump_on_landing = true
		
	if jump_on_landing && Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_on_landing = false
		on_floor_soon = false
		near_floor = false
		

	#  gets input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

