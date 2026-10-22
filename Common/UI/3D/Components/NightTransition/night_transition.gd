extends Control
class_name NightTransition

signal finished()

@export var start_sfx: AudioStream = null
@export var survive_sfx: AudioStream = null

@onready var night_label: Label = $NightLabel
@onready var audio: AudioStreamPlayer = $Audio



func _ready():
    visible = false



func play_intro(night: int):
    visible = true
    modulate = Color.WHITE
    audio.stream = start_sfx
    night_label.text = "NIGHT %d" % night
    night_label.modulate = Color.TRANSPARENT
    night_label.scale = Vector2(2, 2)

    var t = create_tween()
    t.tween_property(night_label, "scale", Vector2.ONE, 0.2)
    t.parallel().tween_property(night_label, "modulate", Color.WHITE, 0.4)
    t.tween_callback(audio.play)
    t.tween_interval(3)
    t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
    t.tween_callback(func():
        visible = false
        finished.emit())
    t.play()



func play_finish():
    visible = true
    modulate = Color.TRANSPARENT
    audio.stream = survive_sfx
    night_label.modulate = Color.TRANSPARENT
    night_label.text = "YOU SURVIVE THE BACKSEATING"

    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, 1)
    t.tween_callback(audio.play)
    t.tween_property(night_label, "modulate", Color.WHITE, 1)
    t.tween_interval(3)
    t.tween_property(night_label, "modulate", Color.TRANSPARENT, 0.5)
    t.tween_callback(func():
        visible = false
        finished.emit())
    t.play()
