extends Control
class_name GameOverScreen

signal closed(to_ingame: bool)

@export var click_sfx: AudioStream = null

@onready var back_to_menu: Button = %BackToMenu
@onready var try_again: Button = %TryAgain
@onready var hint: Label = %Hint
@onready var audio: AudioStreamPlayer = $Audio


func _ready():
    visible = false
    try_again.pressed.connect(_process_click.bind(try_again))
    back_to_menu.pressed.connect(_process_click.bind(back_to_menu))



func show_screen():
    visible = true
    modulate = Color.TRANSPARENT
    try_again.disabled = false
    back_to_menu.disabled = false
    hint.text = Dialogue.hint_pool.pick_random()
    hint.modulate = Color.TRANSPARENT

    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, 2)
    t.tween_property(hint, "modulate", Color.WHITE, 2)
    t.play()


func hide_screen():
    visible = false


func _process_click(button: Button):
    try_again.disabled = true
    back_to_menu.disabled = true
    audio.play()
    closed.emit(button == try_again)