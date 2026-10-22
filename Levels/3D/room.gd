extends Node3D
class_name Room3D

@export var skip_tutorial: bool = false

@onready var window: RoomWindow = %Window
@onready var door: RoomDoor = %Door
@onready var computer: RoomComputer = %Computer
@onready var player: Player3D = $Player3d
@onready var monster: Backseater = $Backseater

@export var current_night: int = 1 # Up to 4

# TODO: Implement level limitations in 2D Game
# TODO: Main menu screen and credits screen with all credits properly listed
# TODO: Need night transition screens when b/n nights
# TODO: Create text message screen for between nights transitions with a start night button -> intro transtiion
# TODO: Need a win screen for surviving the 4 nights
# TODO: Need an animation for player defending themselves (probably throw some paper or something with an audio clip saying spreadsheets)
# TODO: Need night intro sequence that gets re-used when player dies and restarts
# TODO: Need a try again screen when player dies
# TODO: Need to implement sounds on 3d game
# TODO: Need to fix the skybox, looks terrible right now
# TODO: Temporarily here for testing, determine exact details later

func _ready():
    start_night.call_deferred()



func start_night():
    await _play_tutorial()
    computer.start_game(current_night)
    monster.activate(current_night)
    monster.disable_attacks(current_night == 1)



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