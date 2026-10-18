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
    var projectile = projectile_pool.pop_front()
    if projectile: projectile.shoot(target_location, speed)