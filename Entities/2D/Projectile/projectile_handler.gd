extends Node
class_name ProjectileHandler

@export var projectile_spawn_node: Node = null ## Where the projectile is supposed to add child to
@export var projectile_scene: PackedScene = null

@onready var shooter: Node2D = owner as Node2D

var active_projectiles: Array[Projectile] = [] ## Projectiles that are active and cannot be used until despawned
var ready_projectiles: Array[Projectile] = [] ## Projectiles that are idle and can be used to fire

var elapsed_time: float = 0



func create_pool(pool_size: int):
    for i in pool_size:
        var projectile = projectile_scene.instantiate() as Projectile
        projectile_spawn_node.add_child(projectile)
        ready_projectiles.append(projectile)
        projectile.set_shooter(shooter)
        projectile.despawned.connect(ready_projectiles.append.bind(projectile))



func set_pool_data(texture: Texture2D, fireSFX: AudioStream):
    for projectile: Projectile in ready_projectiles:
        projectile.set_data(texture, fireSFX)



func clear_projectiles():
    for projectile: Projectile in active_projectiles:
        projectile.despawn()
        projectile.global_position = shooter.global_position
    active_projectiles.clear()



func shoot(target_location: Vector2, speed: float):
    var count = shooter.get("projectile_count")
    if !count || count is not int: return

    for i in count:
        var projectile = ready_projectiles.pop_front()
        if !projectile: return

        active_projectiles.append(projectile)
        var base_direction := shooter.global_position.direction_to(target_location)
        var offset_angle := 0.
        if i > 0: offset_angle = ((i + 1) / 2) * 10 * (-1 if i % 2 == 1 else 1)
        var direction = base_direction.rotated(deg_to_rad(offset_angle))
        projectile.shoot(direction, speed)