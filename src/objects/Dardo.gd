# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const DEFAULT_VELOCITY = 36.0

#--- public variables - order: export > normal var > onready --------------------------------------

var velocity : float = DEFAULT_VELOCITY

#--- private variables - order: export > normal var > onready -------------------------------------

var _is_stopped : bool = false

onready var _area: Area2D = $Area2D
onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.ARROW_PROJECTILE)


func _physics_process(delta):
	if _is_stopped:
		return
	position.x += velocity * delta

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func stop() -> void:
	_is_stopped = true
	set_physics_process(false)
	_area.set_deferred("monitorable", false)
	global_position = Grid.snap_position(global_position)
	_animator.play("hit")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Area2D_body_entered(body):
	if body is TileMap or body.is_in_group(Constants.GROUPS.DEAD_PLAYER):
		stop()

### -----------------------------------------------------------------------------------------------
