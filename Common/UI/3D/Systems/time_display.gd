extends Label
class_name TimeDisplay

const start_time: float = 7
const end_time: float = 12
const format: String = "%d:%02d"



func _ready():
    SignalBus.game3d_broadcast_time.connect(_update_display)
    SignalBus.game3d_start_intro.connect(func(_night, _skip): text = "7:00")



func _update_display(time_left: float, wait_time: float):
    var minutes_elaspsed = roundi(lerpf(start_time * 60, end_time * 60, 1 - (time_left / wait_time)))
    @warning_ignore("integer_division") text = format % [minutes_elaspsed / 60, minutes_elaspsed % 60]