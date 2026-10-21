extends VBoxContainer
class_name MessageWindow

const max_messages: int = 6
@export var message_scene: PackedScene = null



func _ready():
    SignalBus.hud_2d_sendMessage.connect(_send_message)



func _send_message(msg: String):
    # TODO: Then create a pool of the max amount of messages allowed
    # TODO: Create a spawn in animation for the window similar to receiving messages
    pass