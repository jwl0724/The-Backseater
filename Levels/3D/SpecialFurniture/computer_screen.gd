extends Node3D
class_name RoomComputer

@onready var game_window: SubViewport = $GameScreen

var is_reading_input: bool = false



func toggle_input_reading():
    is_reading_input = !is_reading_input
    Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN if is_reading_input else Input.MOUSE_MODE_VISIBLE

    var event = InputEventAction.new()
    event.action = Constants.Controls.Tab
    event.pressed = is_reading_input
    game_window.push_input(event)



func _input(event: InputEvent):
    if !is_reading_input || event is not InputEventMouse: return
    game_window.push_input(event, false) # Forward mouse position to subviewport