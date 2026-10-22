extends Control
class_name GameOverScreen

@onready var back_to_menu: Button = %BackToMenu
@onready var try_again: Button = %TryAgain
@onready var hint: Label = %Hint



func _ready():
    visible = false
    SignalBus.game3d_gameover.connect(fade_show)
    try_again.pressed.connect(SignalBus.game3d_reset_night.emit)
    back_to_menu.pressed.connect(SignalBus.back_to_menu.emit)



func fade_show():
    visible = true
    modulate = Color.WHITE
    hint.text = Dialogue.hint_pool.pick_random()
    hint.modulate = Color.TRANSPARENT

    var t = create_tween()
    t.tween_property(self, "modulate", Color.TRANSPARENT, 2)
    t.tween_property(hint, "modulate", Color.WHITE, 2)
    t.play()



func fade_out():
    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, 1)
    t.play()