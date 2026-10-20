extends Node3D
class_name RoomComputer

@onready var game_window: SubViewport = $SubViewport



func funnel_input(event: InputEvent):
    game_window.push_input(event)


# TODO: Fix the inputs not being released properly
func release_inputs():
    for action in InputMap.get_actions(): # Cycle through actions and manually release them all
        var release = InputEventAction.new()
        release.action = action
        release.pressed = false
        game_window.push_input(release)