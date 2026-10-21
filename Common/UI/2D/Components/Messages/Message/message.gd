extends ColorRect
class_name Message

@onready var picture: TextureRect = %Picture
@onready var sender: Label = %Sender
@onready var content: Label = %Message



func populate_content(sender_name: String, message: String, profile_picture: Texture2D = null):
    sender.text = sender_name
    content.text = message
    if profile_picture == null: return
    picture.texture = profile_picture # Defaults to monster picture if nothing is provided