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
export var particle_dying_scene : PackedScene

#--- private variables - order: export > normal var > onready -------------------------------------

var _current_player: Player

onready var _spawning_particles : AnimatedSprite = $SpawningParticles
onready var _audio_player : AudioStreamPlayer = $AudioStreamPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_spawning_particles.hide()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func spawn_new_player() -> Player:
	_spawning_particles.show()
	_spawning_particles.play("spawn_start")
	var is_first_player = _current_player == null
	if not is_first_player:
		_audio_player.play()
	yield(_spawning_particles, "animation_finished")
	
	_current_player = player_scene.instance()
	_current_player.global_position = global_position
	_spawning_particles.play("spawn_end")
	return _current_player


func spawn_dead_player(player: Player = null) -> Node2D:
	if player == null:
		player = _current_player
	
	var dead_player = dead_player_scene.instance()
	dead_player.global_position = Grid.snap_player_position(player)
	dead_player.is_flipped = player.is_flipped
	dead_player.connect("tree_entered", self, "_on_dead_player_entered_tree", [dead_player])
	
	return dead_player

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_dead_player_entered_tree(dead_player: Node2D) -> void:
	var dying_particles = particle_dying_scene.instance()
	add_child(dying_particles)
	dying_particles.global_position = dead_player.global_position


func _on_SpawningParticles_animation_finished():
	if _spawning_particles.animation == "spawn_end":
		_spawning_particles.hide()

### -----------------------------------------------------------------------------------------------
