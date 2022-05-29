# Write your doc string for this file here
class_name LevelCamera
extends Camera2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var target : Node2D = null setget _set_target

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree():
	current = true


func _physics_process(_delta):
	if not is_instance_valid(target):
		return
	
	global_position = global_position.linear_interpolate(target.global_position, 0.7)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_target(player):
	target = player
	if is_instance_valid(target) and not current:
		current = true

### -----------------------------------------------------------------------------------------------
