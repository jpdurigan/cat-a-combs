# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var lives : int = 99
export var ambience_sfx : AudioStream
export var game_over_sfx : AudioStream

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_player : Player
var _current_lives : int
var _current_spawner : LevelSpawner

onready var _camera : LevelCamera = $Camera
onready var _initial_spawner : LevelSpawner = $Spawner
onready var _goal : LevelGoal = $Goal

onready var _audio_player : AudioStreamPlayer = $AudioStreamPlayer
onready var _animator : AnimationPlayer = $AnimationPlayer
onready var _game_over_display : Control = $Overlay/GameOver

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	SoundManager.play_ambience(ambience_sfx)
	_game_over_display.hide()
	
	Events.emit_signal("level_started")
	_start_level()
	Events.connect("level_reset", self, "_on_level_reset")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func level_win() -> void:
	pass


func level_lose() -> void:
	_audio_player.stream = game_over_sfx
	_audio_player.play()
	_animator.play("game_over")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _start_level() -> void:
	_current_spawner = _initial_spawner
	_current_lives = lives
	Events.emit_signal("lives_updated", _current_lives)
	_spawn_new_player()


func _reset_level() -> void:
	LoadingManager.load_next_scene(filename)


func _spawn_new_player() -> void:
	_current_player = yield(_current_spawner.spawn_new_player(), "completed")
	call_deferred("add_child", _current_player, true)
	_current_player.connect("player_dead", self, "_on_current_player_dead")
	_camera.target = _current_player


func _spawn_dead_player() -> void:
	var dead_player = _current_spawner.spawn_dead_player(_current_player)
	call_deferred("add_child", dead_player, true)


func _on_current_player_dead() -> void:
	_spawn_dead_player()
	_current_lives -= 1
	Events.emit_signal("lives_updated", _current_lives)
	if _current_lives <= 0:
		level_lose()
	else:
		_spawn_new_player()


func _on_level_reset() -> void:
	_reset_level()


func _on_checkpoint_reached(checkpoint: LevelSpawner) -> void:
	_current_spawner = checkpoint


func _on_Goal_player_reached():
	level_win()


func _on_Retry_pressed():
	_reset_level()
	_game_over_display.hide()

### -----------------------------------------------------------------------------------------------
