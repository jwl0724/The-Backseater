extends Node
class_name Player2DDamageHandler

@onready var player: Player2D = owner as Player2D

var overlapping_enemies: Array[Enemy2D] = []



func try_queue_body(body: Node2D):
    if body is Projectile: hit_via_projectile(body as Projectile)
    elif body is Enemy2D: overlapping_enemies.append(body as Enemy2D)



func try_remove_body(body: Node2D):
    if body is not Enemy2D: return
    var enemy = body as Enemy2D
    overlapping_enemies.remove_at(overlapping_enemies.find(enemy))



func hit_via_enemy(enemy: Enemy2D):
    player.health -= enemy.damage
    player.visuals.toggle_direction(false)
    player.movement.knockback(enemy.global_position.direction_to(player.global_position), enemy.move_speed * (enemy.damage + enemy.max_health) * 2)
    if player.is_dead: kill()
    else:
        player.visuals.play_hurt()
        player.iframe_handler.activate_iframes()



func hit_via_projectile(projectile: Projectile):
    if !projectile.get_collision_layer_value(roundi(log(Constants.PhysLayers.Enemy) / log(2)) + 1): return
    player.ealth -= projectile.projectile_owner.damage
    player.visuals.toggle_direction(false)
    player.movement.knockback(projectile.target_direction, projectile.projectile_speed * 1.5)
    if player.is_dead: kill()
    else: player.visuals.play_hurt()



func kill():
    player.visuals.play_death()
    await player.visuals.death_finished
    player.visible = false



func _process(_delta):
    if overlapping_enemies.size() == 0 || !player.iframe_handler.can_be_damaged: return
    var most_recent_enemy = overlapping_enemies[-1] # Do damage based off most recent enemy
    hit_via_enemy(most_recent_enemy)