# Write your doc string for this file here
class_name LevelSpawner
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var player_scene : PackedScene
export var dead_player_scene : PackedScene

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_player: Player

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	spawn_new_player()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func spawn_new_player() -> Player:
	_current_player = player_scene.instance()
	_current_player.global_position = global_position
	return _current_player


func spawn_dead_player() -> Node2D:
	var dead_player = dead_player_scene.instance()
	dead_player.global_position = _current_player.global_position.snapped(Constants.TILE_GRID / 4)
	return dead_player

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
