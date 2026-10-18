extends AnimatedSprite2D
class_name PlayerVisuals

const move_anim: String = "move"
const idle_anim: String = "idle"

@onready var player: Player2D = owner as Player2D



func _process(_delta):
    # Handle which animation
    if player.velocity.is_zero_approx() && animation == move_anim: play(idle_anim)
    elif !player.velocity.is_zero_approx() && animation == idle_anim: play(move_anim)

    # Handle which direction
    if player.velocity.x < 0: flip_h = true
    elif player.velocity.x > 0: flip_h = false