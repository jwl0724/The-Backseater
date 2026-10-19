extends AnimatedSprite2D
class_name PlayerVisuals

const move_anim: String = "move"
const idle_anim: String = "idle"

signal death_finished()

@onready var player: Player2D = owner as Player2D
@onready var animation_player: AnimationPlayer = $Animations

var handle_direction: bool = true



func reset_visuals():
    animation_player.play("RESET")



func toggle_direction(handle: bool):
    handle_direction = handle



func play_hurt():
    animation_player.play("hurt")



func play_death():
    if flip_h: animation_player.play("die_right")
    else: animation_player.play("die_left")
    stop()
    await animation_player.animation_finished
    death_finished.emit()



func _process(_delta):
    # Handle which animation
    if player.velocity.is_zero_approx() && animation == move_anim: play(idle_anim)
    elif !player.velocity.is_zero_approx() && animation == idle_anim: play(move_anim)

    if !handle_direction: return
    # Handle which direction
    if player.velocity.x < 0: flip_h = true
    elif player.velocity.x > 0: flip_h = false