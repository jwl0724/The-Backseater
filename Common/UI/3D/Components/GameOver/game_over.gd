extends Control
class_name GameOverScreen

@export var click_sfx: AudioStream = null

@onready var back_to_menu: Button = %BackToMenu
@onready var try_again: Button = %TryAgain
@onready var hint: Label = %Hint
@onready var audio: AudioStreamPlayer = $Audio


func _ready():
    visible = false
    SignalBus.game3d_gameover.connect(fade_show)
    try_again.pressed.connect(SignalBus.game3d_reset_night.emit)
    try_again.pressed.connect(_process_click)
    back_to_menu.pressed.connect(SignalBus.back_to_menu.emit)
    back_to_menu.pressed.connect(_process_click)



func fade_show():
    visible = true
    modulate = Color.WHITE
    try_again.disabled = false
    back_to_menu.disabled = false
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



func _process_click():
    try_again.disabled = true
    back_to_menu.disabled = true
    audio.play()