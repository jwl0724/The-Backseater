extends Control
class_name StartScreen

signal finished()

@export var click_sfx: AudioStream = null

@onready var start_button: Button = %Start
@onready var night_label: Label = %NightLabel



func _ready():
    visible = false
    start_button.pressed.connect(_on_start_pressed)



func show_chatlog():
    visible = true
    start_button.disabled = false



func _on_start_pressed():
    start_button.disabled = true
