extends ColorRect

@onready var transition: AnimationPlayer = $AnimationPlayer



func _ready():
    visible = false
    SignalBus.transition_respawn_hide.connect(play_hide)
    SignalBus.transition_respawn_show.connect(play_show)



func play_hide():
    visible = true
    transition.play("transition_hide")
    await transition.animation_finished
    await get_tree().create_timer(0.5).timeout
    SignalBus.game2d_restart.emit()



func play_show():
    transition.play("transition_show")
    await transition.animation_finished
    visible = false