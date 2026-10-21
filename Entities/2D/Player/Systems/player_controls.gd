extends Node
class_name Player2DControls

signal finished_knockback

@onready var player: Player2D = owner as Player2D

var knockback_vector: Vector2 = Vector2()
var handle_inputs: bool = false



func _input(event: InputEvent):
    if event is InputEventMouseMotion: return

    if event.is_action_pressed(Constants.Controls.Tab): handle_inputs = true
    if event.is_action_released(Constants.Controls.Tab): handle_inputs = false


func knockback(direction: Vector2, speed: float):
    knockback_vector = direction * speed



func _physics_process(_delta):
    # Handle knockback
    if knockback_vector.length_squared() > 2:
        player.velocity = knockback_vector
        knockback_vector = knockback_vector.lerp(Vector2.ZERO, player.knockback_recovery_rate)
        if knockback_vector.length_squared() < 2:
            player.velocity = Vector2.ZERO
            finished_knockback.emit()

    elif player.is_dead: return

    else:
        # Handle regular movement
        var input_vector := Input.get_vector(Constants.Controls.Left, Constants.Controls.Right, Constants.Controls.Up, Constants.Controls.Down)
        if !handle_inputs: input_vector = Vector2.ZERO
        player.velocity = input_vector * player.move_speed

    player.move_and_slide()