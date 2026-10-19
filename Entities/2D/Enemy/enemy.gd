extends CharacterBody2D
class_name Enemy2D

enum EnemyType {
    # Slimes
    ACID_SLIME, ANGEL_SLIME, FIRE_SLIME, GOO_SLIME, SOUL_SLIME, WATER_SLIME, FLOWER_SLIME,
    # Fantasy Creatures
    GOBLIN, MINOTAUR, SIREN, GENASI, DRYAD, NEZHA, FAIRY, CENTAUR, AZURE_DRAGON, WUKONG,
    # Insects
    PIXIEFLY, BUBBLE_SPIDER, SOUL_BUG, FIRE_WASP, BOMB_BEETLE, PARASITE, MANTIS_SHRIMP,
    # Ghosts
    WANDERING_SPIRIT, BANSHEE, UMIBOZU, REAPER, DULLAHAN, SHADOW_PERSON
}

signal damaged() # For presentational updates (i.e. sound and visuals)
signal killed() # For presentational updates (i.e. sound and visuals)
signal respawned()

@onready var projectile_handler: ProjectileHandler = %ProjectileHandler
@onready var components: Node2D = $Components
@onready var visuals: EnemyVisuals = %Visuals
@onready var movement: Enemy2DMovement = %EnemyMovement
@onready var xp_orb: XPOrb = %XpOrb


# All Enemy Stats
var type: EnemyType = EnemyType.ACID_SLIME
var damage: float = 0
var move_speed: float = 0
var max_health: float = 0
var health: float = 0
var xp_worth: int = 1

# Shooting Enemy Stats
var attack_speed: float = 0
var projectile_count: int = 0
var projectile_speed: float = 0

var player: Player2D = null
var is_dead: bool:
    get: return health <= 0

var elapsed_time: float = 0



func load_data(data: Enemy2DData):
    projectile_handler.projectile_scene = data.projectile_scene
    type = data.enemy_type
    damage = data.damage
    move_speed = data.move_speed
    max_health = data.health
    health = max_health
    xp_worth = data.xp_worth
    attack_speed = data.attack_speed
    visuals.set_sprite(type)
    respawned.emit()

    if !projectile_handler.projectile_scene: return
    projectile_count = data.projectile_count
    projectile_speed = data.projectile_speed
    if projectile_handler.projectile_pool.size() < ceili(data.attack_speed / 3) * data.projectile_count * Projectile.lifespan:
        projectile_handler.create_pool(ceili(data.attack_speed / 3) * data.projectile_count * ceili(Projectile.lifespan) - projectile_handler.projectile_pool.size())
    projectile_handler.set_pool_data(data.projectile_texture, null) # TODO: Null for now cause no audio implementation yet



func spawn_at_position(global_pos: Vector2):
    components.visible = true
    health = max_health
    global_position = global_pos
    if player != null: movement.start_chasing(player)



func hurt_enemy(projectile: Projectile):
    if is_dead: return
    health -= player.damage
    movement.knockback(projectile.target_direction, projectile.projectile_speed)
    if is_dead: kill()
    else: damaged.emit()



func kill():
    killed.emit()
    await visuals.death_finished
    components.visible = false
    xp_orb.drop_xp(global_position, xp_worth)



func _process(delta):
    if projectile_handler.projectile_scene == null: return
    if elapsed_time >= 3 / attack_speed:
        elapsed_time = 0
        if is_dead || player == null: return
        projectile_handler.shoot(player.global_position, projectile_speed) # TODO: Fix problem where the projectile just despawns early sometimes?
    else: elapsed_time += delta