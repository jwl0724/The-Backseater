extends Node
class_name ProjectileHandler

@export var projectile_spawn_node: Node = null ## Where the projectile is supposed to add child to
@export var projectile_scene: PackedScene = null

@onready var shooter: Node2D = owner as Node2D

var projectile_pool: Array[Projectile] = []

var elapsed_time: float = 0
var fire_rate: float = -1



func create_pool(pool_size: int):
    for i in pool_size:
        var projectile = projectile_scene.instantiate() as Projectile
        projectile_spawn_node.add_child(projectile)
        projectile_pool.append(projectile)
        projectile.set_shooter(shooter)
        projectile.despawned.connect(projectile_pool.append.bind(projectile))



func shoot(target_location: Vector2, speed: float):
    var count = shooter.get("projectile_count")
    if !count || count is not int: return

    for i in count:
        var projectile = projectile_pool.pop_front()
        if !projectile: return

        var base_direction := shooter.global_position.direction_to(target_location)
        var offset_angle := 0.
        if i > 0: offset_angle = ((i + 1) / 2) * 10 * (-1 if i % 2 == 1 else 1)
        var direction = base_direction.rotated(deg_to_rad(offset_angle))
        projectile.shoot(direction, speed)