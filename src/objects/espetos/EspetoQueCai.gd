# Write your doc string for this file here
extends "res://objects/espetos/Espeto.gd"

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var trigger_path := NodePath("./Trigger")
export(float, 0.1, 3.0, 0.01) var gravity_multiplier : float = 0.7

#--- private variables - order: export > normal var > onready -------------------------------------

var _velocity : Vector2 = Vector2.ZERO
var _is_falling : bool = false
var _is_reseting : bool = false

onready var _initial_position : Vector2 = position
onready var _spike : KinematicBody2D = get_node(".")
onready var _trigger : Trigger = get_node_or_null(trigger_path)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	if is_instance_valid(_trigger):
		_trigger.connect("player_triggered", self, "_on_player_triggered")


func _physics_process(delta):
	if _is_reseting and position.y <= _initial_position.y:
		_is_reseting = false
		_velocity = Vector2.ZERO
	
	if _is_reseting:
		_velocity -= Constants.GRAVITY * gravity_multiplier
	elif _is_falling:
		_velocity += Constants.GRAVITY * gravity_multiplier
	
	_velocity = _spike.move_and_slide(_velocity)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_body_collision(body: Node) -> void:
	if body is TileMap:
		_is_reseting = true
		_velocity = Vector2.ZERO
	elif body.is_in_group(Constants.GROUPS.PLAYER):
		queue_free()


func _on_Area2D_area_entered(area):
	_handle_body_collision(area.owner)


func _on_Area2D_body_entered(body):
	_handle_body_collision(body)


func _on_player_triggered() -> void:
	_is_falling = true

### -----------------------------------------------------------------------------------------------
