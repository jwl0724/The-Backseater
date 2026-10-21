extends Node3D
class_name Room3D

@export var skip_tutorial: bool = false

@onready var window: RoomWindow = %Window
@onready var door: RoomDoor = %Door
@onready var computer: RoomComputer = %Computer
@onready var player: Player3D = $Player3d
@onready var monster: Backseater = $Backseater

@export var current_night: int = 1 # Up to 4


# TODO: Temporarily here for testing, determine exact details later
func _ready():
    start_night.call_deferred()



func start_night():
    await _play_tutorial()
    computer.start_game(current_night)



func end_night():
    current_night += 1



func _play_tutorial():
    if skip_tutorial: return
    if current_night == 1:
        SignalBus.game3d_tutorial_play.emit(Dialogue.night1_tutorial)
        await SignalBus.game3d_tutorial_finished
    elif current_night == 2:
        SignalBus.game3d_tutorial_play.emit(Dialogue.night2_tutorial)
        await SignalBus.game3d_tutorial_finished