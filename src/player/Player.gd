class_name Player
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal player_dead

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const GRAVITY = Vector2.DOWN * 32

const ACCELERATION = 80
const JUMP_SPEED = 480
const WALK_SPEED = 240

const JUMP_BUFFER_COUNT = 3

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _velocity := Vector2.ZERO
var _jump_buffer : int = 0

var _target_platform : PlatformMoving = null

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.PLAYER)


func _unhandled_key_input(event: InputEventKey):
	if event.is_echo():
		return
	
	if event.is_action_pressed("ui_up") and is_on_floor():
		_jump_buffer = JUMP_BUFFER_COUNT
	
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		_velocity.x = 0


func _physics_process(_delta: float):
	# Handle platform
	if is_instance_valid(_target_platform):
		position += _target_platform.current_delta
	
	# Handle jump
	if _jump_buffer > 0:
		_jump_buffer -= 1
		if _jump_buffer == 0 or _can_jump():
			_velocity += Vector2(0, -JUMP_SPEED)
			_jump_buffer = 0
	
	# Handle walk
	var walk : Vector2 = (
		Input.get_action_strength("ui_right") * ACCELERATION * Vector2.RIGHT
		+ Input.get_action_strength("ui_left") * ACCELERATION * Vector2.LEFT
	)
	_velocity.x += walk.x
	_velocity.x = min(abs(_velocity.x), WALK_SPEED) * sign(_velocity.x)
	
	# Handle gravity
	_velocity += GRAVITY
	
	# Move
	_velocity = move_and_slide(_velocity, Vector2.UP)


### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func kill():
	emit_signal("player_dead")
	queue_free()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUPS.PLATFORM_MOVING):
		_target_platform = body
	elif body.is_in_group(Constants.GROUPS.SPIKE) or body.is_in_group(Constants.GROUPS.LASER_BEAM):
		kill()
	elif body.is_in_group(Constants.GROUPS.ARROW_PROJECTILE):
		body.stop()
		kill()


func _handle_body_exited(body: Node) -> void:
	if body == _target_platform:
		_target_platform = null


func _can_jump() -> bool:
	var transform_tile_above = transform.translated(Vector2.UP * Constants.TILE_SIZE)
	return not test_move(transform_tile_above, _velocity)


func _on_Area2D_area_entered(area: Area2D):
	if is_queued_for_deletion():
		return
	
	_handle_body_entered(area.owner)


func _on_Area2D_area_exited(area: Area2D):
	if is_queued_for_deletion():
		return
	
	_handle_body_exited(area.owner)

### -----------------------------------------------------------------------------------------------
