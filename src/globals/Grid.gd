class_name Grid
extends Reference


static func snap_position(position: Vector2) -> Vector2:
	return position.snapped(Constants.TILE_GRID / 2)


static func snap_player_position(player: Player) -> Vector2:
	var player_position = player.global_position
	if not player.last_collision:
		pass
	elif (
			player.last_collision.is_in_group(Constants.GROUPS.LASER_BEAM)
			or player.last_collision.is_in_group(Constants.GROUPS.ARROW_PROJECTILE)
	):
		player_position.y = player.last_collision.global_position.y + Constants.TILE_SIZE / 4
	return player_position.snapped(Constants.TILE_GRID / 4)


static func get_player_global_position(node: Node) -> Vector2:
	var player : Node2D = node.get_tree().get_nodes_in_group(Constants.GROUPS.PLAYER).front()
	return player.global_position
