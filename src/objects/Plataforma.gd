extends StaticBody2D

const TILE_SIZE = 16
const VELOCITY = 24

export var move : Vector2

onready var _initial_position := global_position 
onready var _tween : Tween = $Tween

func _ready():
	call_deferred("tween_forward")


func tween_forward():
	var time = (move * TILE_SIZE).length() / VELOCITY
	_tween.interpolate_property(self, "global_position", _initial_position, _initial_position + move * TILE_SIZE, time)
	_tween.start()


func tween_backward():
	var time = (move * TILE_SIZE).length() / VELOCITY
	_tween.interpolate_property(self, "global_position", _initial_position + move * TILE_SIZE, _initial_position, time)
	_tween.start()


func _on_Tween_tween_completed(object, key):
	if key != ":global_position":
		return
	
	if global_position != _initial_position:
		tween_backward()
	else:
		tween_forward()
