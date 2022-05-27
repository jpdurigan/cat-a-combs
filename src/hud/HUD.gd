# Write your doc string for this file here
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _game_icons : Control = $PanelContainer/Buttons/Game
onready var _lives : Label = $PanelContainer/Buttons/Game/Lives/Label
onready var _reset : TextureButton = $PanelContainer/Buttons/Game/Reset
onready var _music : TextureButton = $PanelContainer/Buttons/Music
onready var _audio : TextureButton = $PanelContainer/Buttons/Audio

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.HUD)
	_music.set_pressed_no_signal(SoundManager.is_bgm_on)
	_audio.set_pressed_no_signal(SoundManager.is_sfx_on)
	
	Events.connect("level_started", self, "_on_level_started")
	Events.connect("lives_updated", self, "_on_lives_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_level_started() -> void:
	if not _game_icons.visible:
		_game_icons.show()


func _on_lives_updated(value: int) -> void:
	_lives.text = "x%s" % [value]


func _on_Reset_pressed():
	Events.emit_signal("level_reset")


func _on_Music_toggled(button_pressed: bool):
	SoundManager.is_bgm_on = button_pressed


func _on_Audio_toggled(button_pressed: bool):
	SoundManager.is_sfx_on = button_pressed

### -----------------------------------------------------------------------------------------------

