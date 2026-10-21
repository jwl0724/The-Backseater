extends Node3D
class_name RoomComputer

@onready var alert_sound: AudioStreamPlayer3D = $AlertSound
@onready var game_window: SubViewport = $GameScreen
@onready var minigame: MiniGame = $GameScreen/Minigame

var is_reading_input: bool = false



func start_game(level: int):
    minigame.start_game(level)




func enable_inputs(enable: bool):
    is_reading_input = enable
    Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN if enable else Input.MOUSE_MODE_VISIBLE

    var event = InputEventAction.new()
    event.action = Constants.Controls.Tab
    event.pressed = enable
    game_window.push_input(event)



func _input(event: InputEvent):
    if !is_reading_input || event is not InputEventMouse: return
    game_window.push_input(event, false) # Forward mouse position to subviewport