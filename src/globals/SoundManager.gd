# warning-ignore-all:return_value_discarded
# Write your doc string for this file here
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

var BGM_BUS = AudioServer.get_bus_index("BGM")
var SFX_BUS = AudioServer.get_bus_index("SFX")
var WORLD_BUS = AudioServer.get_bus_index("World")

const PLAYER_OFF = -80
const PLAYER_ON = 0

const BGM_TRANSITION_DURATION = 1.2
const AMBIENCE_TRANSTION_DURATION = 2.1

#--- public variables - order: export > normal var > onready --------------------------------------

export var menu_music : AudioStream
export var game_music : AudioStream

var is_bgm_on : bool = true setget _set_is_bgm_on
var is_sfx_on : bool = true setget _set_is_sfx_on

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_bgm : AudioStream = null
var _backup_bgm : AudioStream = null
var _current_ambience : AudioStream = null

onready var _bgm_player: AudioStreamPlayer = $BGM
onready var _bgm_player_alt: AudioStreamPlayer = $BGM2
onready var _ambience_player: AudioStreamPlayer = $Ambience
onready var _ambience_player_alt: AudioStreamPlayer = $Ambience2
onready var _ui_player: AudioStreamPlayer = $UI
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree():
	Events.connect("main_menu_entered", self, "_on_main_menu_entered")
	Events.connect("level_started", self, "_on_level_started")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func play_bgm(bgm_stream: AudioStream) -> void:
	if bgm_stream == _current_bgm:
		return
	_current_bgm = bgm_stream
	if _current_bgm != null:
		_backup_bgm = _current_bgm
	_handle_transition(
			_bgm_player, _bgm_player_alt,
			_current_bgm, BGM_TRANSITION_DURATION, is_bgm_on
	)


func play_ambience(ambience_stream: AudioStream) -> void:
	if ambience_stream == _current_ambience:
		return
	_current_ambience = ambience_stream
	_handle_transition(
			_ambience_player, _ambience_player_alt,
			_current_ambience, AMBIENCE_TRANSTION_DURATION, is_sfx_on
	)


func play_ui_sfx(ui_sfx_stream: AudioStream) -> void:
	_ui_player.stream = ui_sfx_stream
	_ui_player.play()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_transition(
		player_1: AudioStreamPlayer,
		player_2: AudioStreamPlayer,
		stream: AudioStream,
		duration: float,
		is_bus_on: bool
) -> void:
	var playing_stream = _get_playing_stream(player_1, player_2)
	var next_stream = _get_non_playing_stream(player_1, player_2)
	
	_tween.interpolate_property(
			playing_stream, "volume_db",
			PLAYER_ON, PLAYER_OFF, duration * 2/3,
			Tween.TRANS_EXPO, Tween.EASE_OUT
	)
	_tween.interpolate_callback(playing_stream, duration, "stop")
	
	if stream != null and is_bus_on:
		next_stream.stream = stream
		next_stream.volume_db = PLAYER_OFF
		_tween.interpolate_property(
				next_stream, "volume_db",
				PLAYER_OFF, PLAYER_ON, duration,
				Tween.TRANS_EXPO, Tween.EASE_OUT
		)
		_tween.interpolate_callback(next_stream, 0.0, "play")
	_tween.start()


func _get_playing_stream(player_1: AudioStreamPlayer, player_2: AudioStreamPlayer) -> AudioStreamPlayer:
	var playing_stream := player_1 if player_1.playing else player_2
	return playing_stream


func _get_non_playing_stream(player_1: AudioStreamPlayer, player_2: AudioStreamPlayer) -> AudioStreamPlayer:
	var all_streams := [player_1, player_2]
	var playing_stream := _get_playing_stream(player_1, player_2)
	all_streams.erase(playing_stream)
	return all_streams.front()


func _set_is_bgm_on(value: bool) -> void:
	is_bgm_on = value
	if is_bgm_on:
		play_bgm(_backup_bgm)
	else:
		play_bgm(null)


func _set_is_sfx_on(value: bool) -> void:
	is_sfx_on = value
	AudioServer.set_bus_mute(SFX_BUS, not is_sfx_on)


func _on_main_menu_entered() -> void:
	AudioServer.set_bus_mute(WORLD_BUS, true)
	if not is_instance_valid(_bgm_player):
		yield(self, "ready")
	play_bgm(menu_music)


func _on_level_started() -> void:
	AudioServer.set_bus_mute(WORLD_BUS, false)
	play_bgm(game_music)

### -----------------------------------------------------------------------------------------------
