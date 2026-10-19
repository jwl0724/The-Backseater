extends CharacterBody2D
class_name Player2D

# Physics constants
const knockback_recovery_rate: float = 0.25
const projectile_speed: float = 80

# Upgrade stats
const damage_per_upgrade: float = 1
const move_speed_per_upgrade: float = 10
const health_per_upgrade: float = 5
const health_regen_per_upgrade: float = 0.2
const attack_speed_per_upgrade: float = 1
const projectile_count_per_upgrade: int = 2

# Base stats on spawn in
@export var base_damage: float = 1
@export var base_move_speed: float = 30
@export var base_health: float = 20
@export var base_health_regen: float = 0.1
@export var base_attack_speed: float = 1 ## the attack interval will be 3 / attack_speed
@export var base_projectile_count: int = 1

# Node components
@onready var camera: Camera2D = $Camera
@onready var hitbox: Area2D = $Hitbox

# System components
@onready var xp_handler: Player2DXPHandler = $Systems/XPHandler
@onready var projectile_handler: ProjectileHandler = $Systems/ProjectileHandler
@onready var movement: Player2DControls = $Systems/PlayerControls
@onready var visuals: PlayerVisuals = $Components/Sprite
@onready var damage_handler: Player2DDamageHandler = $Systems/DamageHandler
@onready var iframe_handler: Player2DIFrames = $Systems/IFrameHandler

# Run time stats
var damage: float = base_damage
var move_speed: float = base_move_speed
var max_health: float = base_health
var health: float = max_health
var health_regen: float = base_health_regen
var attack_speed: float = base_attack_speed
var projectile_count: int = base_projectile_count

# Run time variables
var elasped_time: float = 0

# Run time getters
var fire_rate: float:
    get: return 3 / attack_speed
var is_dead: bool:
    get: return health <= 0


# TODO: Create the mini-game loop that runs indefinitely until a stop signal
# TODO: Connect upgrade menu and upgrades to player after player reaches xp threshold
# TODO: Implement level restarting



func _ready():
    # TODO: Remove the setters down here later, only need this cause export sets the value late
    damage = base_damage
    move_speed = base_move_speed
    max_health = base_health
    health = max_health
    health_regen = base_health_regen
    attack_speed = base_attack_speed
    projectile_count = base_projectile_count
    projectile_handler.create_pool(40)

    hitbox.body_entered.connect(damage_handler.try_queue_body)
    hitbox.body_exited.connect(damage_handler.try_remove_body)
    movement.finished_knockback.connect(visuals.toggle_direction.bind(true))
    SignalBus.game2d_player_upgrade.connect(_on_upgrade)



func teleport_to_point(pos: Vector2):
    camera.position_smoothing_enabled = false
    global_position = pos
    camera.set.bind("position_smoothing_enabled", true).call_deferred()



func collect_xp(amount: int):
    xp_handler.add_xp(amount)



func respawn(respawn_point: Vector2):
    damage = base_damage
    move_speed = base_move_speed
    max_health = base_health
    health = max_health
    health_regen = base_health_regen
    attack_speed = base_attack_speed
    projectile_count = base_projectile_count
    visuals.reset_visuals()
    teleport_to_point(respawn_point)



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
        if is_dead: return
        projectile_handler.shoot(get_global_mouse_position(), projectile_speed)
    else: elasped_time += delta