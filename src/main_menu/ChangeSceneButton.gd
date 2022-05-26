# Write your doc string for this file here
tool
extends Button

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Play_pressed():
	LoadingManager.load_next_scene(_next_scene_path)

### -----------------------------------------------------------------------------------------------



### Next Scene Snippet ----------------------------------------------------------------------------

var _next_scene_path : String

func _get_property_list() -> Array:
	var properties := []
	
	var resource_property = {
		"name" : "next_scene",
		"type" : TYPE_OBJECT,
		"usage" : PROPERTY_USAGE_EDITOR,
	}
	properties.append(resource_property)
	
	var resource_path_property = {
		"name" : "_next_scene_path",
		"type" : TYPE_STRING,
		"usage" : PROPERTY_USAGE_NOEDITOR,
	}
	properties.append(resource_path_property)
	
	return properties


func _set(property, value):
	if property == "next_scene" and value is PackedScene:
		_next_scene_path = value.resource_path


func _get(property):
	var to_return = null
	if property == "next_scene" and ResourceLoader.exists(_next_scene_path):
		to_return = load(_next_scene_path)
	return to_return

### -----------------------------------------------------------------------------------------------
