extends HBoxContainer
class_name ChatLine

@export var player_profile_picture: Texture2D = null

@onready var message: Message = $Message
@onready var spacer: Control = $Spacer



func set_content(sender: String, text: String):
    message.show_content(false)
    if sender == Dialogue.backseater_name:
        message.populate_content(sender, text)
        move_child(message, 0)
    else:
        message.populate_content(sender, text, player_profile_picture)
        move_child(spacer, 0)