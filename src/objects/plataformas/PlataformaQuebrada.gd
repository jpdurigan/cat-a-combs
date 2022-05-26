# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.PLATFORM_FALLING)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func fall() -> void:
	_animator.play("fall")
	yield(_animator, "animation_finished")
	queue_free()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Area2D_area_entered(area: Area2D):
	if _animator.is_playing():
		return
	
	if area.owner.is_in_group(Constants.GROUPS.PLAYER):
		fall()

### -----------------------------------------------------------------------------------------------
