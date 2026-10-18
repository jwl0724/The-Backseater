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

@onready var visuals: EnemyVisuals = %Visuals
@onready var movement: Enemy2DMovement = %EnemyMovement

var projectile_template: PackedScene = null

# TODO: Make enemies drop xp orbs based on the amount of xp they are worth

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


func load_data(data: Enemy2DData):
    type = data.enemy_type
    damage = data.damage
    move_speed = data.move_speed
    max_health = data.health
    health = max_health
    visuals.set_sprite(type)

    if !data.projectile_scene: return
    projectile_template = data.projectile_scene
    projectile_count = data.projectile_count
    projectile_speed = data.projectile_speed



func spawn_at_position(global_pos: Vector2):
    visible = true
    health = max_health
    global_position = global_pos
    if player != null: movement.start_chasing(player)


# TODO: Disable turning of sprite when being knocked back
func hurt_enemy(projectile: Projectile):
    health -= player.damage
    movement.knockback(projectile.target_direction, projectile.projectile_speed)
    if is_dead: kill()
    else: visuals.play_hurt_animation()



func kill():
    visuals.play_die_animation()
    await visuals.death_finished
    visible = false