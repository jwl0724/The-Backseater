extends Node3D
class_name RoomComputer

@onready var game_window: SubViewport = $SubViewport

var is_reading_input: bool = false



func toggle_input_reading():
    is_reading_input = !is_reading_input
    var event = InputEventAction.new()
    event.action = Constants.Controls.Tab
    event.pressed = is_reading_input
    game_window.push_input(event)