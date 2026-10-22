extends Control
class_name NightIntro

signal finished()

@onready var night_label: Label = $NightLabel
@onready var audio: AudioStreamPlayer = $Audio



func _ready():
    visible = false
    SignalBus.game3d_start_night.connect(play_intro)


func play_intro(night: int):
    visible = true
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
        finished.emit()
    )
    t.play()