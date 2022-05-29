# Write your doc string for this file here
tool
extends TileMap

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var light_only_material : Material

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		material = null
	else:
		material = light_only_material
	_set_material_on_children(self)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_material_on_children(parent: Node2D) -> void:
	for child in parent.get_children():
		var node2d : Node2D = child as Node2D
		if node2d == null:
			continue
		node2d.use_parent_material = true
		if node2d.get_child_count() > 0:
			_set_material_on_children(node2d)

### -----------------------------------------------------------------------------------------------
