class_name Player
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal player_dead

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const ACCELERATION = 15
const JUMP_SPEED = 360
const WALK_SPEED = 160

const JUMP_BUFFER_COUNT = 3

const WALK_SFX_FRAMES = [4, 9]

#--- public variables - order: export > normal var > onready --------------------------------------

export(Array, AudioStream) var step_sfxs : Array
export(Array, AudioStream) var jump_sfxs : Array

var is_flipped: bool = false

#--- private variables - order: export > normal var > onready -------------------------------------

var _velocity := Vector2.ZERO
var _jump_buffer : int = 0

var _target_platform : PlatformMoving = null

onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.PLAYER)
	_sprite.play("spawning")


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
			_sprite.animation = "jump_start"
			_play_jump_sound()
	
	# Handle walk
	var walk : Vector2 = (
		Input.get_action_strength("ui_right") * ACCELERATION * Vector2.RIGHT
		+ Input.get_action_strength("ui_left") * ACCELERATION * Vector2.LEFT
	)
	_velocity.x += walk.x
	_velocity.x = min(abs(_velocity.x), WALK_SPEED) * sign(_velocity.x)
	
	# Handle gravity
	_velocity += Constants.GRAVITY
	
	# Move
	_velocity = move_and_slide(_velocity, Vector2.UP)
	_handle_sprite(walk)


### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func kill():
	emit_signal("player_dead")
	queue_free()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_sprite(input_vector: Vector2) -> void:
	var is_walking = input_vector.x != 0
	# Handle left/right 
	if is_walking:
		is_flipped = true if input_vector.x < 0 else false
		_sprite.flip_h = is_flipped
	
	if _sprite.animation == "spawning":
		return
	
	# Handle left/right and walk 
	if input_vector.x != 0:
		var anim_name = "walk" if is_on_floor() else "idle"
		_sprite.animation = anim_name
	elif _sprite.animation == "walk":
		_play_step_sound()
		_sprite.animation = "idle"
	
	# Handle jump
	if _velocity.y != 0 and not is_on_floor():
		if _sprite.animation in ["idle", "jump_up", "jump_down"]:
			var anim_name = "jump_down" if _velocity.y > 0 else "jump_up"
			_sprite.animation = anim_name
	if is_on_floor() and "jump" in _sprite.animation:
		_play_step_sound()
		_sprite.animation = "jump_end"
	
	# Handle step sfx
	if _sprite.animation == "walk" and WALK_SFX_FRAMES.has(_sprite.frame):
		_play_step_sound()


func _play_step_sound() -> void:
	if _audio_player.playing or step_sfxs.empty():
		return
	
	var new_step_sound : AudioStream = _audio_player.stream
	if step_sfxs.size() > 1:
		while new_step_sound == _audio_player.stream:
			new_step_sound = step_sfxs[randi() % step_sfxs.size()]
	
	_audio_player.stream = new_step_sound
	_audio_player.play()


func _play_jump_sound() -> void:
	if jump_sfxs.empty():
		return
	
	if _audio_player.playing:
		_audio_player.stop()
	
	var jump_sound : AudioStream = jump_sfxs[randi() % jump_sfxs.size()]
	_audio_player.stream = jump_sound
	_audio_player.play()


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


func _on_AnimatedSprite_animation_finished():
	match _sprite.animation:
		"jump_start":
			_sprite.animation = "jump_up"
		"spawning":
			_sprite.animation = "idle"
		"jump_end":
			_sprite.animation = "idle"

### -----------------------------------------------------------------------------------------------
