extends Resource
class_name Enemy2DData

@export var enemy_type: Enemy2D.EnemyType = Enemy2D.EnemyType.ACID_SLIME

@export_group("Stats")
@export var damage: float = 2
@export var move_speed: float = 20
@export var health: float = 10
@export var xp_worth: int = 1

@export_group("Ranged Stats")
@export var attack_speed: float = 0
@export var projectile_scene: PackedScene = null ## This must be included if enemy shoots projectile, if nothing is provided then it's assumed the enemy is melee
@export var projectile_texture: Texture2D = null ## This must be included if a projectile scene is provided
@export var projectile_sound: AudioStream = null
@export var projectile_count: int = 1
@export var projectile_speed: float = 20