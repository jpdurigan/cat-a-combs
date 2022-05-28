# Write your doc string for this file here
extends LevelSpawner

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animated_sprite : AnimatedSprite = $AnimatedSprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_animated_sprite.play("off")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func activate() -> void:
	Events.emit_signal("checkpoint_reached", self)
	_animated_sprite.play("activate")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Trigger_player_triggered():
	activate()


func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation == "activate":
		_animated_sprite.play("on")

### -----------------------------------------------------------------------------------------------
