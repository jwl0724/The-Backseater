extends Node
class_name Enemy2DMovement

const knockback_recovery_rate: float = 0.25

@onready var enemy: Enemy2D = owner as Enemy2D

var player: Player2D = null
var knockback_vector: Vector2 = Vector2.ZERO



func start_chasing(player_ref: Player2D):
    player = player_ref



func knockback(direction: Vector2, proj_speed: float):
    knockback_vector = direction * proj_speed * 0.8 # Slightly dampen the force



func _physics_process(_delta):
    if enemy.is_dead: return

    # Handle knockback physics
    if knockback_vector.length_squared() > 2:
        enemy.velocity = knockback_vector
        knockback_vector = knockback_vector.lerp(Vector2.ZERO, knockback_recovery_rate)
        if knockback_vector.length_squared() < 2:
            knockback_vector = Vector2.ZERO
            enemy.velocity = Vector2.ZERO

    # Handle normal chasing
    else:
        if player == null || player.is_dead: return
        enemy.velocity = enemy.global_position.direction_to(player.global_position) * enemy.move_speed

    enemy.move_and_slide()
