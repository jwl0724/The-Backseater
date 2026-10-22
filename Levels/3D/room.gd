extends Node3D
class_name Room3D

@export var skip_tutorial: bool = false
@export var night_duration: float = 5 * 60
@export var current_night: int = 1 # Up to 4

@export var hud_scene: PackedScene = null

@onready var night_timer: Timer = $NightTimer
@onready var window: RoomWindow = %Window
@onready var door: RoomDoor = %Door
@onready var computer: RoomComputer = %Computer
@onready var player: Player3D = $Player3d
@onready var monster: Backseater = $Backseater


# TODO: Implement level limitations in 2D Game
# TODO: Main menu screen and credits screen with all credits properly listed
# TODO: Need a win screen for surviving the 4 nights
# TODO: Need an animation for player defending themselves (probably throw some paper or something with an audio clip saying spreadsheets)
# TODO: Need night intro sequence that gets re-used when player dies and restarts
# TODO: Need to implement sounds on 3d game
# TODO: Need to fix the skybox, looks terrible right now
# TODO: Temporarily here for testing, determine exact details later

func _ready():
    player.controls_enabled = false
    night_timer.wait_time = night_duration
    night_timer.timeout.connect(end_night)

    # Setup signals
    SignalBus.game3d_hud_addUI.emit(hud_scene)
    SignalBus.game3d_start_night.connect(start_night)
    SignalBus.game3d_start_nextNightSetup.connect(setup_next_night)
    SignalBus.game3d_reset_night.connect(func(): print("TODO: Implement via a dedicated function later"))

    # Starting signals
    SignalBus.transition_fade_show.emit(1)
    SignalBus.game3d_start_intro.emit(current_night, true)



func start_night():
    player.controls_enabled = true
    await _play_tutorial()

    night_timer.start()
    computer.start_game(current_night)
    monster.activate(current_night)
    monster.disable_attacks(current_night == 1)

    # Handle gimmicks
    computer.disable_sounds(current_night >= 2) # Night 2 gimmick
    if current_night >= 3: SignalBus.game2d_mechanic_ultraZoom.emit()



func end_night():
    monster.reset()
    player.controls_enabled = false
    computer.stop_game()
    computer.enable_inputs(false)
    SignalBus.game3d_end_night.emit()



func setup_next_night():
    if current_night <= 4:
        door.fix_door()
        window.fix_window()
        computer.clear_screen()
        player.reset_player()
        current_night += 1
        SignalBus.transition_fade_show.emit(1)
        SignalBus.game3d_start_intro.emit(current_night, true)
    else:
        print("TODO: Make a win screen and link it to that")



func _play_tutorial():
    if skip_tutorial: return
    if current_night == 1:
        SignalBus.game3d_tutorial_play.emit(Dialogue.night1_tutorial)
        await SignalBus.game3d_tutorial_finished
    elif current_night == 2:
        SignalBus.game3d_tutorial_play.emit(Dialogue.night2_tutorial)
        await SignalBus.game3d_tutorial_finished