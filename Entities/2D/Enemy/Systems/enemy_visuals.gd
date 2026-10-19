extends AnimatedSprite2D
class_name EnemyVisuals

signal death_finished()

@onready var enemy: Enemy2D = owner as Enemy2D
@onready var move_player: AnimationPlayer = $Move
@onready var hurt_player: AnimationPlayer = $Hurt



func _ready():
    enemy.damaged.connect(play_hurt_animation)
    enemy.killed.connect(play_die_animation)



func set_sprite(enemy_type: Enemy2D.EnemyType):
    var track_name: String = Enemy2D.EnemyType.keys()[enemy_type].to_lower()
    play(track_name)
    hurt_player.play("RESET")
    move_player.play("move")
    move_player.speed_scale = enemy.move_speed / 20



func play_hurt_animation():
    hurt_player.play("hurt")



func play_die_animation():
    if flip_h: hurt_player.play("die_right")
    else: hurt_player.play("die_left")
    stop() # Stop the sprite from being animated
    await hurt_player.animation_finished
    death_finished.emit()



func _process(_delta):
    if enemy.is_dead: return

    # Stop animation if player is dead
    if enemy.player.is_dead && move_player.is_playing(): move_player.stop()

    # Handle direction
    if !enemy.movement.knockback_vector.is_zero_approx(): return
    if enemy.velocity.x < 0: flip_h = true
    elif enemy.velocity.x > 0: flip_h = false