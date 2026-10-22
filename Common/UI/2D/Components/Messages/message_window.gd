extends VBoxContainer
class_name MessageWindow

const max_messages: int = 5
@export var message_scene: PackedScene = null

var message_pool: Array[Message] = []



func _ready():
    _create_pool()
    SignalBus.hud_2d_sendMessage.connect(_send_message)



func _send_message(msg: String):
    var message = message_pool.pop_front()
    if !message: return
    add_child(message)
    message.populate_content(Dialogue.backseater_name, msg)
    message.show_content(true)



func _create_pool():
    for i in max_messages:
        var message = message_scene.instantiate() as Message
        message.expired.connect(_remove_from_window.bind(message))
        message_pool.append(message)



func _remove_from_window(message):
    message_pool.append(message)
    remove_child(message)