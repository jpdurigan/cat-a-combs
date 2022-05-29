# Write your doc string for this file here
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

var BGM_BUS = AudioServer.get_bus_index("BGM")
var SFX_BUS = AudioServer.get_bus_index("SFX")

#--- public variables - order: export > normal var > onready --------------------------------------

export var menu_music : AudioStream
export var game_music : AudioStream

var is_bgm_on : bool = true setget _set_is_bgm_on
var is_sfx_on : bool = true setget _set_is_sfx_on

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _bgm_player: AudioStreamPlayer = $BGM
onready var _ambience_player: AudioStreamPlayer = $Ambience
onready var _ui_player: AudioStreamPlayer = $UI
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	Events.connect("main_menu_entered", self, "_on_main_menu_entered")
	Events.connect("level_started", self, "_on_level_started")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func play_bgm(bgm_stream: AudioStream) -> void:
	if bgm_stream == _bgm_player.stream:
		return
	_bgm_player.stream = bgm_stream
	_bgm_player.play()


func play_ambience(ambience_stream: AudioStream) -> void:
	if ambience_stream == _ambience_player.stream:
		return
	_ambience_player.stream = ambience_stream
	_ambience_player.play()


func play_ui_sfx(ui_sfx_stream: AudioStream) -> void:
	_ui_player.stream = ui_sfx_stream
	_ui_player.play()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_bgm_on(value: bool) -> void:
	is_bgm_on = value
	AudioServer.set_bus_mute(BGM_BUS, not is_bgm_on)


func _set_is_sfx_on(value: bool) -> void:
	is_sfx_on = value
	AudioServer.set_bus_mute(SFX_BUS, not is_sfx_on)


func _on_main_menu_entered() -> void:
	play_bgm(menu_music)


func _on_level_started() -> void:
	play_bgm(game_music)

### -----------------------------------------------------------------------------------------------
