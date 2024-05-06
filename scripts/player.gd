extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_buffer = $JumpBuffer
@onready var coyote_timer = $CoyoteTimer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false

func jump():
	velocity.y = JUMP_VELOCITY
	is_jumping = true
	jump_buffer.stop()
	coyote_timer.stop()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_jumping && velocity.y >= 0:
		is_jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || !coyote_timer.is_stopped():
			jump()
		elif !is_on_floor():
			jump_buffer.start()
	
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

	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if !is_on_floor() && was_on_floor && !is_jumping:
		coyote_timer.start()
	if is_on_floor() && !jump_buffer.is_stopped():
		jump()
	

