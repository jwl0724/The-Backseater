extends Control
class_name StartScreen

signal finished()

@export var chat_line_template: PackedScene = null

@onready var message_container: VBoxContainer = %Messages
@onready var start_button: Button = %Start
@onready var sender_name: Label = %ChatName
@onready var night_label: Label = %NightLabel
@onready var audio: AudioStreamPlayer = $Audio



func _ready():
    visible = false
    sender_name.text = Dialogue.backseater_name
    start_button.pressed.connect(_on_start_pressed)



func show_chatlog(night: int):
    visible = true
    start_button.disabled = false
    night_label.text = "NIGHT %d" % night

    _clear_chatlog()
    var chatlog = _get_chat_history(night)
    for chat: Dialogue.MessageContent in chatlog:
        var chatline = chat_line_template.instantiate() as ChatLine
        message_container.add_child(chatline)
        chatline.set_content(chat.sender, chat.content)



func _on_start_pressed():
    start_button.disabled = true
    audio.play()
    finished.emit()



func _clear_chatlog():
    for child: Control in message_container.get_children():
        child.queue_free()



func _get_chat_history(night: int) -> Array[Dialogue.MessageContent]:
    if night == 1: return Dialogue.night1_exchange
    elif night == 2: return Dialogue.night2_exchange
    elif night == 3: return Dialogue.night3_exchange
    else: return Dialogue.night4_exchange # Only ever 1 to 4