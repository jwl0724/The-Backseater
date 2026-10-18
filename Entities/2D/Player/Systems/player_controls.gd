extends Node
class_name Player2DControls

signal finished_knockback

@onready var player: Player2D = owner as Player2D

var input_vector: Vector2 = Vector2()
var knockback_vector: Vector2 = Vector2()


func _input(event: InputEvent):
    if event is InputEventMouseMotion: return
    # Can't use get_input_vector cause it'll read inputs when in 3D view as well
    if event.is_action_pressed(Constants.Controls.Up): input_vector.y -= 1
    elif event.is_action_released(Constants.Controls.Up): input_vector.y += 1

    if event.is_action_pressed(Constants.Controls.Down): input_vector.y += 1
    elif event.is_action_released(Constants.Controls.Down): input_vector.y -= 1

    if event.is_action_pressed(Constants.Controls.Left): input_vector.x -= 1
    elif event.is_action_released(Constants.Controls.Left): input_vector.x += 1

    if event.is_action_pressed(Constants.Controls.Right): input_vector.x += 1
    elif event.is_action_released(Constants.Controls.Right): input_vector.x -= 1



func knockback(direction: Vector2, speed: float):
    knockback_vector = direction * speed



func _physics_process(_delta):
    if player.is_dead: return # TODO: Enemy as well, want to make it so knockback vector still goes when dying -> sliding enemy dies

    # Handle knockback
    if knockback_vector.length_squared() > 2:
        player.velocity = knockback_vector
        knockback_vector = knockback_vector.lerp(Vector2.ZERO, player.knockback_recovery_rate)
        if knockback_vector.length_squared() < 2:
            player.velocity = Vector2.ZERO
            finished_knockback.emit()

    else:
        # Handle regular movement
        player.velocity = input_vector.normalized() * player.move_speed

    player.move_and_slide()