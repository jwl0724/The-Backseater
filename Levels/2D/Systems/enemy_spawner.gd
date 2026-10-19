extends Node
class_name EnemySpawner

@export var level1_enemy_set: Array[Enemy2DData] = []
@export var level2_enemy_set: Array[Enemy2DData] = []
@export var level3_enemy_set: Array[Enemy2DData] = []
@export var level4_enemy_set: Array[Enemy2DData] = []

var enemy_pool: Array[Enemy2D] = []
var dead_enemies: Array[Enemy2D] = []

# TODO: Create a pool of enemies to re-use
# TODO: Spawn from outside the camera
# TODO: Create the data for all enemies
# TODO: Call dead enemy's respawn function to get them to be re-used
# TODO: Have some sort of weighted spawning