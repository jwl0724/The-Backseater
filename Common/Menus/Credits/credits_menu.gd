extends Control
class_name CreditsMenu

@onready var back_button: Button = %Back
@onready var scroll: ScrollContainer = %Scroll



func _ready():
    visible = false
    back_button.pressed.connect(func(): visible = false)



func show_credits():
    scroll.get_v_scroll_bar().value = 0
    visible = true