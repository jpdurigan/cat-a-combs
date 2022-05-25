# Constantes do jogo
class_name Constants
extends Reference

const TILE_SIZE = 16
const TILE_GRID = Vector2(TILE_SIZE, TILE_SIZE)

const GRAVITY = Vector2.DOWN * 32

const GROUPS = {
	PLAYER = "player",
	DEAD_PLAYER = "dead_player",
	
	PLATFORM_MOVING = "platform_moving",
	PLATFORM_FALLING = "platform_falling",
	
	SPIKE = "spike",
	ARROW_SHOOTER = "arrow_shooter",
	ARROW_PROJECTILE = "arrow_projectile",
	LASER_SHOOTER = "laser_shooter",
	LASER_BEAM = "laser_beam",
}
