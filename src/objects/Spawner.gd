# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal player_spawned(player)

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

func spawn_new_player() -> void:
	_current_player = player_scene.instance()
	_current_player.global_position = global_position
	owner.call_deferred("add_child", _current_player, true)
	_current_player.connect("player_dead", self, "_on_current_player_dead")


func spawn_dead_player() -> void:
	var dead_player = dead_player_scene.instance()
	dead_player.global_position = _current_player.global_position.snapped(Constants.TILE_GRID / 4)
	owner.add_child(dead_player, true)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_current_player_dead() -> void:
	spawn_dead_player()
	spawn_new_player()

### -----------------------------------------------------------------------------------------------
