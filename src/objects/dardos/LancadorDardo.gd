# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const DEFAULT_VELOCITY = 36.0
const DEFAULT_INTERVAL = 5.0

#--- public variables - order: export > normal var > onready --------------------------------------

export var projectile_scene : PackedScene
export var velocity : float = DEFAULT_VELOCITY
export var interval : float = DEFAULT_INTERVAL
export var is_active : bool = true

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _projectiles: Node2D = $Projectiles
onready var _timer: Timer = $Timer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
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


func _on_Timer_timeout():
	if is_active:
		shoot()

### -----------------------------------------------------------------------------------------------
