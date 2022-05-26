# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var is_flipped : bool = false setget _set_is_flipped

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sprite : AnimatedSprite = $AnimatedSprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.DEAD_PLAYER)
	_sprite.set_deferred("playing", true)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_flipped(value: bool) -> void:
	is_flipped = value
	if not is_inside_tree():
		yield(self, "ready")
	_sprite.flip_h = is_flipped

### -----------------------------------------------------------------------------------------------
