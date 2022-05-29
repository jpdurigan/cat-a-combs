# Write your doc string for this file here
tool
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const DEFAULT_VELOCITY = 216.0
const DEFAULT_INTERVAL = 4.0

#--- public variables - order: export > normal var > onready --------------------------------------

export var projectile_scene : PackedScene
export var velocity : float = DEFAULT_VELOCITY
export var interval : float = DEFAULT_INTERVAL
export var is_active : bool = true
export var listening_rect : Rect2 setget _set_listening_rect

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _projectiles: Node2D = $Projectiles
onready var _timer: Timer = $Timer

onready var _audio_player : AudioStreamPlayer = $AudioStreamPlayer
onready var _visibility : VisibilityNotifier2D = $VisibilityNotifier2D

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		_set_listening_rect(listening_rect)
		return
	add_to_group(Constants.GROUPS.ARROW_SHOOTER)
	_clear_children()
	_timer.wait_time = interval
	if is_active:
		shoot()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func shoot() -> void:
	_sprite.play("shooting_start")
	yield(_sprite, "animation_finished")
	
	if _visibility.is_on_screen():
		_audio_player.play()
	var projectile : Projectile = projectile_scene.instance()
	projectile.velocity = velocity
	_projectiles.add_child(projectile, true)
	_sprite.play("shooting_end")
	if is_active:
		_timer.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _clear_children() -> void:
	for child in _projectiles.get_children():
		_projectiles.remove_child(child)
		child.queue_free()


func _set_listening_rect(value: Rect2) -> void:
	listening_rect = value
	if not is_inside_tree():
		yield(self, "ready")
	_visibility.rect = listening_rect


func _on_Timer_timeout():
	if is_active:
		shoot()

### -----------------------------------------------------------------------------------------------
