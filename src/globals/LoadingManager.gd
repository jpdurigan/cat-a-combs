# Write your doc string for this file here
extends CanvasLayer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _loader : ResourceInteractiveLoader

onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _progress: ProgressBar = $ColorRect/ProgressBar

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _process(_delta):
	if not is_instance_valid(_loader):
		set_process(false)
		return
	
	var error = _loader.poll()
	_progress.value = _loader.get_stage()
	if error == ERR_FILE_EOF:
		_progress.value = _progress.max_value
		set_process(false)
		_on_end_of_file()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func load_next_scene(path: String) -> void:
	if is_instance_valid(_loader) or path.empty():
		assert(false, "Algo de errado não está certo!")
	
	if not get_tree().paused:
		get_tree().paused = true
	
	_loader = ResourceLoader.load_interactive(path)
	_progress.max_value = _loader.get_stage_count()
	_progress.min_value = 0.0
	_progress.value = 0.0
	
	_animator.play("open")
	yield(_animator, "animation_finished")
	set_process(true)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_end_of_file() -> void:
	var next_scene = _loader.get_resource()
	var _err = get_tree().change_scene_to(next_scene)
	_animator.play("close")
	yield(_animator, "animation_finished")
	if get_tree().paused:
		get_tree().paused = false
	_loader = null

### -----------------------------------------------------------------------------------------------
