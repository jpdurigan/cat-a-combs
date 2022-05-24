extends KinematicBody2D

const GRAVITY = Vector2.DOWN * 18
const ACCELERATION = 45
const JUMP_SPEED = 340
const WALK_SPEED = 120

const JUMP_BUFFER_COUNT = 3

export var dead : PackedScene

var velocity := Vector2.ZERO
var _jump_buffer : int = 0

func _unhandled_key_input(event: InputEventKey):
	if event.is_echo():
		return
	
	if event.is_action_pressed("ui_up") and is_on_floor():
#		velocity += Vector2(0, -JUMP_SPEED)
		_jump_buffer = JUMP_BUFFER_COUNT
	
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		velocity.x = 0


func _physics_process(delta):
#	if Input.is_action_pressed("ui_left"):
#		breakpoint
	if _jump_buffer > 0:
		_jump_buffer -= 1
		var transform_check = transform.translated(Vector2.UP * 16)
		if not test_move(transform_check, velocity) or _jump_buffer == 0:
			printt("jump", delta, _jump_buffer)
			velocity += Vector2(0, -JUMP_SPEED)
			_jump_buffer = 0
	
	var walk : Vector2 = (
		Input.get_action_strength("ui_right") * ACCELERATION * Vector2.RIGHT
		+ Input.get_action_strength("ui_left") * ACCELERATION * Vector2.LEFT
	)
	
	velocity.x += walk.x
	var velocity1 = velocity
	var velocity2 = sign(velocity.x)
	var velocity3 = min(velocity.x, WALK_SPEED)
	velocity.x = min(abs(velocity.x), WALK_SPEED) * sign(velocity.x)
	velocity += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)


func kill():
	var body : Node2D = dead.instance()
	body.global_position = global_position
	owner.add_child(body, true)


func _on_Area2D_area_entered(area: Area2D):
	if area.owner.is_in_group("espeto"):
		kill()
