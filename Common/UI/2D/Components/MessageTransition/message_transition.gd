extends ColorRect

@onready var transition: AnimationPlayer = $AnimationPlayer
@onready var message: Label = $Label



func _ready():
    visible = false
    SignalBus.transition_message_hide.connect(play_hide)
    SignalBus.transition_message_show.connect(play_show)



func play_hide(text: String):
    visible = true
    message.text = text
    transition.play("transition_hide")
    await transition.animation_finished
    await get_tree().create_timer(0.5).timeout
    SignalBus.transition_message_finished.emit()



func play_show():
    transition.play("transition_show")
    await transition.animation_finished
    visible = false
    SignalBus.transition_message_finished.emit()