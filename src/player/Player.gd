class_name Player
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal player_dead

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const GRAVITY = Vector2.DOWN * 18

const ACCELERATION = 45
const JUMP_SPEED = 240
const WALK_SPEED = 120

const JUMP_BUFFER_COUNT = 3

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _velocity := Vector2.ZERO
var _jump_buffer : int = 0

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
	if body.is_in_group(Constants.GROUPS.SPIKE):
		kill()


func _can_jump() -> bool:
	var transform_tile_above = transform.translated(Vector2.UP * Constants.TILE_SIZE)
	return not test_move(transform_tile_above, _velocity)


func _on_Area2D_area_entered(area: Area2D):
	if is_queued_for_deletion():
		return
	
	_handle_body_entered(area.owner)

### -----------------------------------------------------------------------------------------------
