# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var lives : int = 3

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_player : Player
var _current_lives : int

onready var _camera : LevelCamera = $Camera
onready var _spawner : LevelSpawner = $Spawner
onready var _goal : LevelGoal = $Goal

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_spawn_first_player()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func level_win() -> void:
	get_tree().paused = true
	$Overlay/TemporaryDisplay.show()
	$Overlay/TemporaryDisplay/Center/Label.text = "YOU WIN!"


func level_lose() -> void:
	get_tree().paused = true
	$Overlay/TemporaryDisplay.show()
	$Overlay/TemporaryDisplay/Center/Label.text = "YOU LOSE!"

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _spawn_first_player() -> void:
	_current_lives = lives
	_spawn_new_player()


func _spawn_new_player() -> void:
	_current_player = yield(_spawner.spawn_new_player(), "completed")
	call_deferred("add_child", _current_player, true)
	_current_player.connect("player_dead", self, "_on_current_player_dead")
	_camera.target = _current_player


func _spawn_dead_player() -> void:
	var dead_player = _spawner.spawn_dead_player()
	call_deferred("add_child", dead_player, true)


func _on_current_player_dead() -> void:
	_spawn_dead_player()
	_current_lives -= 1
	if _current_lives <= 0:
		level_lose()
	else:
		_spawn_new_player()


func _on_Goal_player_reached():
	level_win()

### -----------------------------------------------------------------------------------------------
