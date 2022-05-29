# Write your doc string for this file here
extends LevelSpawner

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _is_active : bool = false
var _was_activated : bool = false

onready var _animated_sprite : AnimatedSprite = $AnimatedSprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_animated_sprite.play("off")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func activate() -> void:
	if _is_active or _was_activated:
		return
	Events.emit_signal("checkpoint_reached", self)
	_animated_sprite.play("activate")
	_is_active = true
	_was_activated = true


func deactivate() -> void:
	_animated_sprite.play("off")
	_is_active = false

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_checkpoint_reached(checkpoint) -> void:
	if checkpoint != self and _is_active:
		deactivate()


func _on_Trigger_player_triggered():
	if _was_activated:
		return
	activate()


func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation == "activate":
		_animated_sprite.play("on")

### -----------------------------------------------------------------------------------------------
