extends AudioStreamPlayer3D
class_name AmbienceConstant



func _ready():
    SignalBus.game3d_start_night.connect(play)
    SignalBus.game3d_end_night.connect(stop)