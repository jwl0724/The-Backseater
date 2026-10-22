extends Control
class_name WinScreen

signal closed()

@export var chat_line_template: PackedScene = null

@onready var scroll: ScrollContainer = %Scroll
@onready var message_container: VBoxContainer = %Messages
@onready var typing_line: Label = %Typing
@onready var menu_button: Button = %Menu
@onready var sender_name: Label = %ChatName
@onready var audio: AudioStreamPlayer = $Audio

var is_typing_line: Label = null



func _ready():
    visible = false
    menu_button.visible = false
    menu_button.disabled = true
    menu_button.modulate = Color.TRANSPARENT
    menu_button.pressed.connect(closed.emit)



func play_end_sequence():
    var t = create_tween()
    for message: Dialogue.MessageContent in Dialogue.ending_exchange:
        var chatline = chat_line_template.instantiate() as ChatLine
        t.tween_callback(func():
            message_container.add_child(chatline)
            chatline.set_content(message.sender, message.text))
