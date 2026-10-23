extends Control
class_name CreditsMenu

@onready var back_button: Button = %Back
@onready var scroll: ScrollContainer = %Scroll
@onready var label: RichTextLabel = %Label



func _ready():
    visible = false



func show_credits():
    pass