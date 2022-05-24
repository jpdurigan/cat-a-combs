class_name Grid
extends Reference


static func snap_position(position: Vector2) -> Vector2:
	return position.snapped(Constants.TILE_GRID / 4)


static func get_player_global_position(node: Node) -> Vector2:
	var player : Node2D = node.get_tree().get_nodes_in_group(Constants.GROUPS.PLAYER).front()
	return player.global_position
