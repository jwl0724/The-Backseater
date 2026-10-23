extends Control

@onready var label: Label = $Label



func _ready():
    label.modulate = Color.TRANSPARENT

    var t = create_tween()
    t.tween_property(label, "modulate", Color.WHITE, 1)
    t.tween_interval(2)
    t.tween_callback(func():
        SignalBus.transition_fade_hide.emit(1)
        SignalBus.back_to_menu.emit())
    t.play()