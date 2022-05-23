extends KinematicBody2D

const GRAVITY = Vector2(0, 64)

const JUMP_SPEED = 600
const WALK_SPEED = 180

var velocity := Vector2.ZERO


func _unhandled_key_input(event: InputEventKey):
	if event.is_echo():
		return
	
	if event.is_action_pressed("ui_up") and is_on_floor():
		velocity += Vector2(0, -JUMP_SPEED)


func _physics_process(delta):
	var walk : Vector2 = (
		Input.get_action_strength("ui_right") * WALK_SPEED * Vector2.RIGHT +
		Input.get_action_strength("ui_left") * WALK_SPEED * Vector2.LEFT
	)
	
	velocity.x = walk.x
	velocity += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
