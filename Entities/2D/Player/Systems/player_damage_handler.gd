extends Node
class_name Player2DDamageHandler

@onready var player: Player2D = owner as Player2D

var overlapping_enemies: Array[Enemy2D] = []



func try_queue_body(body: Node2D):
    if body is Projectile: hit_via_projectile(body as Projectile) # Redunant for now cause projectile calls harm function, but just leave it in case need to change it in the future
    elif body is Enemy2D: overlapping_enemies.append(body as Enemy2D)



func try_remove_body(body: Node2D):
    if body is not Enemy2D: return
    var enemy = body as Enemy2D
    overlapping_enemies.remove_at(overlapping_enemies.find(enemy))



func hit_via_enemy(enemy: Enemy2D):
    if enemy.is_dead: return
    player.health -= enemy.damage
    player.visuals.toggle_direction(false)
    player.movement.knockback(enemy.global_position.direction_to(player.global_position), enemy.move_speed * enemy.damage)
    if player.is_dead: kill()
    else:
        player.visuals.play_hurt()
        player.iframe_handler.activate_iframes()



func hit_via_projectile(projectile: Projectile):
    if !player.iframe_handler.can_be_damaged || player.is_dead: return
    if !projectile.get_collision_layer_value(roundi(log(Constants.PhysLayers.Enemy) / log(2)) + 1): return
    player.health -= projectile.projectile_owner.damage
    player.visuals.toggle_direction(false)
    player.movement.knockback(projectile.target_direction, projectile.projectile_speed * 2)
    if player.is_dead: kill()
    else:
        player.visuals.play_hurt()
        player.iframe_handler.activate_iframes()



func kill():
    player.visuals.play_death()
    await player.visuals.death_finished
    player.visible = false
    player.killed.emit()



func _process(_delta):
    if overlapping_enemies.size() == 0 || !player.iframe_handler.can_be_damaged || player.is_dead: return
    var index = overlapping_enemies.find_custom(func(e): return e.is_dead == false) # Get the first enemy that's not dead
    if index != -1: hit_via_enemy(overlapping_enemies[index])