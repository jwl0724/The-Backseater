extends CharacterBody2D
class_name Player2D

const knockback_recovery_rate: float = 0.25

const damage_per_upgrade: float = 1
const move_speed_per_upgrade: float = 10
const health_per_upgrade: float = 5
const health_regen_per_upgrade: float = 0.2
const attack_speed_per_upgrade: float = 1
const projectile_count_per_upgrade: int = 1

const projectile_speed: float = 80

@export var base_damage: float = 1
@export var base_move_speed: float = 30
@export var base_health: float = 20
@export var base_health_regen: float = 0.1
@export var base_attack_speed: float = 1 ## the attack interval will be 3 / attack_speed
@export var base_projectile_count: int = 1

@onready var camera: Camera2D = $Camera2D
@onready var projectile_handler: ProjectileHandler = $Systems/ProjectileHandler
@onready var hitbox: Area2D = $Hitbox
@onready var animations: AnimationPlayer = $Animations
@onready var player_movement: Player2DControls = $Systems/PlayerControls
@onready var visuals: PlayerVisuals = $Sprite

var damage: float = base_damage
var move_speed: float = base_move_speed
var max_health: float = base_health
var health: float = max_health
var health_regen: float = base_health_regen
var attack_speed: float = base_attack_speed
var projectile_count: float = base_projectile_count

var fire_rate: float:
    get: return 3 / attack_speed
var is_dead: bool:
    get: return health <= 0

var elasped_time: float = 0

# TODO: Make it not shoot after player died
# TODO: Make player not shoot anymore after dying
# TODO: Actually implement a dying state
# TODO: Connect IFrames
# TODO: Make hurt animations
# TODO: Make death animation
# TODO: Make the shooting shoot at an angle when projectile count is > 1
# TODO: Make the camera stay within the boundaries of the map
# TODO: Add collisions on the edges of the map so player can't leave
# TODO: Create the mini-game loop that runs indefinitely until a stop signal
# TODO: Connect upgrade menu and upgrades to player after player reaches xp threshold
# TODO: Create xp handler to handle xp gains and calculate next level threshold
# TODO: Implement level restarting



func _ready():
    move_speed = base_move_speed
    projectile_handler.create_pool(20)

    hitbox.body_entered.connect(_try_hit_player)
    player_movement.finished_knockback.connect(visuals.toggle_direction.bind(true))

    SignalBus.game2d_player_upgrade.connect(_on_upgrade)



func teleport_to_point(pos: Vector2):
    camera.position_smoothing_enabled = false
    global_position = pos
    camera.set.bind("position_smoothing_enabled", true).call_deferred()



func _try_hit_player(body: Node2D):
    if body is not Enemy2D: return
    var enemy = body as Enemy2D
    health -= enemy.damage
    visuals.toggle_direction(false)
    player_movement.knockback(enemy.global_position.direction_to(global_position), enemy.move_speed * (enemy.damage + enemy.max_health) * 2)



func _on_upgrade(type: UpgradeData.UpgradeType):
    match type:
        UpgradeData.UpgradeType.DAMAGE: damage += damage_per_upgrade
        UpgradeData.UpgradeType.MOVE_SPEED: move_speed += move_speed_per_upgrade
        UpgradeData.UpgradeType.HEALTH_REGEN: health_regen += health_regen_per_upgrade
        UpgradeData.UpgradeType.ATTACK_SPEED: attack_speed += attack_speed_per_upgrade
        UpgradeData.UpgradeType.PROJECTILE_COUNT: projectile_count += projectile_count_per_upgrade
        UpgradeData.UpgradeType.HEALTH:
            var health_percent = health / max_health
            max_health += health_per_upgrade
            health = max_health * health_percent



func _process(delta):
    if elasped_time >= fire_rate:
        elasped_time = 0
        projectile_handler.shoot(get_global_mouse_position(), projectile_speed)
    else: elasped_time += delta