extends CharacterBody2D
class_name Player2D

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

var damage: float = base_damage
var move_speed: float = base_move_speed
var max_health: float = base_health
var health: float = max_health
var health_regen: float = base_health_regen
var attack_speed: float = base_attack_speed
var projectile_count: float = base_projectile_count

var fire_rate: float:
    get: return 3 / attack_speed
var elasped_time: float = 0



func _ready():
    move_speed = base_move_speed
    projectile_handler.create_pool(20)
    SignalBus.game2d_player_upgrade.connect(_on_upgrade)



func teleport_to_point(pos: Vector2):
    camera.position_smoothing_enabled = false
    global_position = pos
    camera.set.bind("position_smoothing_enabled", true).call_deferred()



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