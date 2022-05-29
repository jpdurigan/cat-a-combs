# Write your doc string for this file here
tool
#class_name PlatformMoving
extends Path2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var current_delta : Vector2 = Vector2.ZERO

export var time_move : float = 3.0
export var time_stop : float = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

var _last_progress_position : Vector2

onready var _path_follow: PathFollow2D = $PathFollow2D
onready var _tween : Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		curve.resource_local_to_scene = true
		return
	add_to_group(Constants.GROUPS.PLATFORM_MOVING)
	tween_forward()


func _physics_process(delta: float):
	current_delta = (_path_follow.position - _last_progress_position)
	_last_progress_position = _path_follow.position

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func tween_forward():
	_tween.interpolate_property(_path_follow, "unit_offset", 0.0, 1.0, time_move)
	_tween.start()


func tween_backward():
	_tween.interpolate_property(_path_follow, "unit_offset", 1.0, 0.0, time_move)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Tween_tween_completed(object: Object, _key: NodePath):
	if object != _path_follow:
		return
	
	yield(get_tree().create_timer(time_stop), "timeout")
	if _path_follow.unit_offset != 0.0:
		tween_backward()
	else:
		tween_forward()

### -----------------------------------------------------------------------------------------------
