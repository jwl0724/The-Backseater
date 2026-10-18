extends AnimatedSprite2D
class_name EnemyVisuals

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



func _process(_delta):
    # Handle direction
    if enemy.velocity.x < 0: flip_h = true
    elif enemy.velocity.x > 0: flip_h = false