extends AudioStreamPlayer3D
class_name RandomAmbience

@export var ambience_clips: Array[AudioStream] = []
@export var lower_interval: float = 30
@export var upper_interval: float = 90
@export var chance_to_play: float = 1

var timer: Timer = null



func _ready():
    timer = Timer.new()
    timer.one_shot = false
    timer.autostart = false
    timer.wait_time = randf_range(lower_interval, upper_interval)
    timer.timeout.connect(_on_timeout)
    add_child(timer)

    SignalBus.game3d_start_night.connect(timer.start)
    SignalBus.game3d_end_night.connect(timer.stop)
    SignalBus.game3d_gameover.connect(timer.stop)



func _on_timeout():
    stream = ambience_clips.pick_random()
    if randf() < chance_to_play: play()
    timer.wait_time = randf_range(lower_interval, upper_interval)
    timer.start()