# Write your doc string for this file here
extends "res://objects/espetos/Espeto.gd"

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var trigger_path := NodePath("./Trigger")
export var spawn_time : float = 2.0
export(float, 0.1, 3.0, 0.01) var gravity_multiplier : float = 0.7

#--- private variables - order: export > normal var > onready -------------------------------------

var _velocity : Vector2 = Vector2.ZERO
var _is_falling : bool = false

onready var _initial_position : Vector2 = position

onready var _area : Area2D = $Area2D
onready var _animator : AnimationPlayer = $AnimationPlayer
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
	if _is_falling:
		_animator.play("falling")
		_velocity += Constants.GRAVITY * gravity_multiplier
	
	_velocity = _spike.move_and_slide(_velocity)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_body_collision(body: Node) -> void:
	if not is_instance_valid(body) or body.is_queued_for_deletion() or not _is_falling:
		return
	
	var has_hit_player = body.is_in_group(Constants.GROUPS.PLAYER)
	_area.set_deferred("monitoring", false)
	_area.set_deferred("monitorable", false)
	_is_falling = false
	_velocity = Vector2.ZERO
	
	_animator.play("impact")
	yield(_animator, "animation_finished")
	
	if has_hit_player:
		queue_free()
	else:
		yield(get_tree().create_timer(spawn_time), "timeout")
		global_position = _initial_position
		
		_area.set_deferred("monitoring", true)
		_area.set_deferred("monitorable", true)
		_animator.play("idle")


func _on_Area2D_area_entered(area):
	_handle_body_collision(area.owner)


func _on_Area2D_body_entered(body):
	_handle_body_collision(body)


func _on_player_triggered() -> void:
	_is_falling = true

### -----------------------------------------------------------------------------------------------
