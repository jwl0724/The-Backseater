extends AnimatedSprite2D
class_name EnemyVisuals

signal death_finished()

@onready var enemy: Enemy2D = owner as Enemy2D
@onready var move_player: AnimationPlayer = $Move
@onready var hurt_player: AnimationPlayer = $Hurt



func set_sprite(enemy_type: Enemy2D.EnemyType):
    var track_name: String = Enemy2D.EnemyType.keys()[enemy_type].to_lower()
    play(track_name)
    move_player.play("move")
    move_player.speed_scale = enemy.move_speed / 20



func play_hurt_animation():
    hurt_player.play("hurt")



func play_die_animation():
    if flip_h: hurt_player.play("die_right")
    else: hurt_player.play("die_left")
    await hurt_player.animation_finished
    death_finished.emit()



func _process(_delta):
    if enemy.is_dead: return

    # Handle direction
    if enemy.velocity.x < 0: flip_h = true
    elif enemy.velocity.x > 0: flip_h = false