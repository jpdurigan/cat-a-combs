# warning-ignore-all:return_value_discarded
# warning-ignore-all:integer_division
tool
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var tile_count : int = 1 setget _set_tile_count
export var target := Vector2.ZERO setget _set_target
export var move_time : float = 3.0
export var stop_time : float = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_target : Vector2
var _is_stopped : bool = false

onready var _initial_position : Vector2 = global_position
onready var _target_position = global_position + target * Constants.TILE_SIZE
onready var _default_distance = _initial_position.distance_to(_target_position)

onready var _tilemap : TileMap = $TileMap
onready var _area : Area2D = $Area2D
onready var _collision_shape : RectangleShape2D = shape_owner_get_shape(0, 0)
onready var _detection_shape : RectangleShape2D = _area.shape_owner_get_shape(0, 0)
onready var _tween : Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		set_physics_process(false)
		_handle_tile_changes()
		return
	
	yield(get_tree().create_timer(stop_time), "timeout")
	move_forwards()


func _draw():
	if not Engine.editor_hint or target == Vector2.ZERO:
		return
	var upper_left_offset = Vector2(tile_count, 1) * Constants.TILE_SIZE / 2
	var rect_position = target * Constants.TILE_GRID - upper_left_offset
	var rect_size = Vector2(tile_count, 1) * Constants.TILE_SIZE
	var rect := Rect2(rect_position, rect_size)
	var color = Color("80fdfed1")
	draw_rect(rect, color)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func move_forwards() -> void:
	_tween.remove_all()
	_current_target = _target_position
	var time = move_time * (global_position.distance_to(_target_position) / _default_distance)
	_tween.interpolate_property(
		self, "global_position", global_position, _target_position, time
	)
	_tween.start()


func move_backwards() -> void:
	_tween.remove_all()
	_current_target = _initial_position
	var time = move_time * (global_position.distance_to(_initial_position) / _default_distance)
	_tween.interpolate_property(
		self, "global_position", global_position, _initial_position, time
	)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _change_current_target() -> void:
	if _is_stopped:
		return
	_is_stopped = true
	yield(get_tree().create_timer(stop_time), "timeout")
	if _current_target == _initial_position:
		move_forwards()
	else:
		move_backwards()
	_is_stopped = false


func _handle_tile_changes() -> void:
	_tilemap.clear()
	for x in range(tile_count):
		_tilemap.set_cell(x, 0, 0)
		_tilemap.update_bitmask_area(Vector2(x, 0))
	_tilemap.position = Vector2(- tile_count * Constants.TILE_SIZE / 2, - Constants.TILE_SIZE / 2)
	
	_collision_shape.extents.x = tile_count * Constants.TILE_SIZE / 2
	_detection_shape.extents.x = (tile_count * Constants.TILE_SIZE / 2) - 1


func _set_tile_count(value: int) -> void:
	tile_count = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_handle_tile_changes()
	update()


func _set_target(value: Vector2) -> void:
	target = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	update()


func _on_Tween_tween_completed(_object, key):
	if key != ":global_position":
		return
	
	_change_current_target()


func _on_Area2D_body_entered(body: Node):
	if body == self or body.is_in_group(Constants.GROUPS.PLAYER) or _is_stopped:
		return
	
	_tween.remove_all()
	_change_current_target()

### -----------------------------------------------------------------------------------------------
