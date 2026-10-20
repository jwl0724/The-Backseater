extends Node3D
class_name Room3D

@onready var window: RoomWindow = %Window
@onready var door: RoomDoor = %Door
@onready var player: Player3D = $Player3d

@export var current_night: int = 1 # Up to 4


# TODO: Temporarily here for testing, determine exact details later
func _ready():
    start_night.call_deferred()



func start_night():
    _play_tutorial()
    SignalBus.game3d_start_night.emit()



func end_night():
    current_night += 1



func _play_tutorial():
    if current_night == 1: SignalBus.game3d_tutorial_play.emit(Dialogue.night1_tutorial)
    elif current_night == 2: SignalBus.game3d_tutorial_play.emit(Dialogue.night2_tutorial)