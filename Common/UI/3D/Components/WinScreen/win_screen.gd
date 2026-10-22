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

var end_tween: Tween = null



func _ready():
    visible = false
    typing_line.visible = false
    menu_button.visible = false
    menu_button.disabled = true

    menu_button.pressed.connect(func(): if !end_tween || !end_tween.is_running(): closed.emit())
    scroll.get_v_scroll_bar().changed.connect(func(): scroll.get_v_scroll_bar().value = int(scroll.get_v_scroll_bar().max_value))



func show_screen(to_show: bool):
    visible = to_show



func play_end_sequence():
    visible = true
    menu_button.visible = true
    menu_button.modulate = Color.TRANSPARENT
    menu_button.disabled = false

    end_tween = create_tween()

    var delay: bool = false
    # Live dialogue animation
    for message: Dialogue.MessageContent in Dialogue.ending_exchange:
        if message.sender == Dialogue.backseater_name:
            if delay: end_tween.tween_interval(1)
            end_tween.tween_callback(func():
                message_container.move_child(typing_line, message_container.get_child_count() - 1)
                typing_line.visible = true)

        end_tween.tween_interval(1.5)
        end_tween.tween_callback(func(): typing_line.visible = false)

        var chatline = chat_line_template.instantiate() as ChatLine
        end_tween.tween_callback(func():
            message_container.add_child(chatline)
            chatline.set_content(message.sender, message.content))
        delay = true

    end_tween.tween_interval(1)
    end_tween.tween_property(menu_button, "modulate", Color.WHITE, 2)
    end_tween.play()
