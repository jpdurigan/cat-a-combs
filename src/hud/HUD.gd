# Write your doc string for this file here
extends CanvasLayer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sound_hud : Control = $Sound
onready var _music : TextureButton = $Sound/MarginContainer/Buttons/Music
onready var _audio : TextureButton = $Sound/MarginContainer/Buttons/Audio

onready var _game_hud : Control = $Game
onready var _lives : Label = $Game/MarginContainer/Buttons/Lives/Label
onready var _reset : Button = $Game/MarginContainer/Buttons/Reset
onready var _reset_sprite : AnimatedSprite = $Game/MarginContainer/Buttons/Reset/AnimatedSprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	add_to_group(Constants.GROUPS.HUD)
	_music.set_pressed_no_signal(SoundManager.is_bgm_on)
	_audio.set_pressed_no_signal(SoundManager.is_sfx_on)
	
	Events.connect("main_menu_entered", self, "_on_main_menu_entered")
	Events.connect("level_started", self, "_on_level_started")
	Events.connect("lives_updated", self, "_on_lives_updated")


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_reset"):
		_reset_level()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _reset_level() -> void:
	_reset_sprite.play("pressed")
	Events.emit_signal("level_reset")


func _on_main_menu_entered() -> void:
	if _game_hud.visible:
		_game_hud.hide()


func _on_level_started() -> void:
	if _game_hud.visible:
		yield(_reset_sprite, "animation_finished")
	else:
		_game_hud.show()
	_reset_sprite.play("normal")


func _on_lives_updated(value: int) -> void:
	_lives.text = "x%s" % [value]


func _on_Reset_pressed():
	_reset_level()


func _on_Music_toggled(button_pressed: bool):
	SoundManager.is_bgm_on = button_pressed


func _on_Audio_toggled(button_pressed: bool):
	SoundManager.is_sfx_on = button_pressed

### -----------------------------------------------------------------------------------------------

