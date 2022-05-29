# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var fall_time : float = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _initial_position : Vector2 = global_position
onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_animator.play("RESET")
	add_to_group(Constants.GROUPS.PLATFORM_FALLING)
	Events.connect("player_dead", self, "_on_player_dead")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func fall() -> void:
	_animator.play("about_to_fall")
	yield(get_tree().create_timer(fall_time), "timeout")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	_animator.play("fall")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _respawn() -> void:
	global_position = _initial_position
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	_animator.play("RESET")


func _on_player_dead() -> void:
	_respawn()


func _on_Area2D_area_entered(area: Area2D):
	if _animator.is_playing():
		return
	
	if area.owner.is_in_group(Constants.GROUPS.PLAYER):
		fall()

### -----------------------------------------------------------------------------------------------
