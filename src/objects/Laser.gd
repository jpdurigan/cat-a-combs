# Write your doc string for this file here
tool
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var extension : float = 0.0 setget _set_extension
export var is_growing : bool = true setget _set_is_growing

var velocity : float = 160.0

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sprite : Sprite = $Sprite
onready var _area : Area2D = $Area2D
onready var _shape : RectangleShape2D = _area.shape_owner_get_shape(0, 0)
onready var _raycast1 : RayCast2D = $RayCast1
onready var _raycast2 : RayCast2D = $RayCast2

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if Engine.editor_hint:
		set_physics_process(false)
		return
	add_to_group(Constants.GROUPS.LASER_BEAM)
	if is_growing:
		_set_is_growing(is_growing)


func _physics_process(delta: float):
	if not is_growing or Engine.editor_hint:
		set_physics_process(false)
		return
	if _raycast1.is_colliding() or _raycast2.is_colliding():
		_handle_size_on_collision()
		return
	self.extension += velocity * delta

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _handle_collision_with(body: Node) -> void:
	if (
			body.is_queued_for_deletion()
			or body.is_in_group(Constants.GROUPS.LASER_BEAM)
	):
		return
	
	_handle_size_on_collision()


func _handle_size_on_collision() -> void:
	_update_raycasts()
	
	var possible_tips := []
	if _raycast1.is_colliding():
		possible_tips.append(to_local(_raycast1.get_collision_point()))
	if _raycast2.is_colliding():
		possible_tips.append(to_local(_raycast2.get_collision_point()))
	
	var tip : Vector2 = Vector2(extension, 0)
	for possible_tip in possible_tips:
		if possible_tip.x < tip.x:
			tip = possible_tip
	
	self.extension = round(tip.x)


func _update_raycasts() -> void:
	_raycast1.force_raycast_update()
	_raycast2.force_raycast_update()


func _set_extension(value: float) -> void:
	extension = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_sprite.offset.y = - extension / 2
	_sprite.region_rect.size.y = extension
	_area.position.x = extension / 2
	_shape.extents.x = extension / 2
	_raycast1.cast_to.x = extension
	_raycast2.cast_to.x = extension


func _set_is_growing(value: bool) -> void:
	is_growing = value
	set_physics_process(is_growing)
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_raycast1.enabled = is_growing
	_raycast2.enabled = is_growing


func _on_Area2D_body_entered(body: Node):
	_handle_collision_with(body)


func _on_Area2D_area_entered(area: Area2D):
	_handle_collision_with(area.owner)

### -----------------------------------------------------------------------------------------------
